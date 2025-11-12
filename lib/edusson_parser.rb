require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mysql2'

module Parser
  class EdussonParser

    def self.run
      logger.info 'started'
      loop do
        parse_categories
        category_url = get_next_category
        unless category_url
          sleep 30
          exit
        end
        parse_products(category_url)
      end
    rescue StandardError
      O14::ExceptionHandler.log_exception('academic_help_parser')
      sleep 30
    rescue Interrupt
      logger.info('The script was interrupted')
    end

    private


    def self.get_next_category
      return db[:edusson_categories].where(is_processed: 0).first
    end

    def self.parse_products(category)
      get_pages_range(category[:url], category[:id]).each { |page_num|
        logger.info page_num
        page_template = "#{category[:url]}/page/#{page_num}"
        agent = Mechanize.new
        page_with_blogs = agent.get(page_template)
        page_links = page_with_blogs.search('#post-container a.paper-card-link').to_a
        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 10
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              logger.info link['href']
              edusson_products = db[:edusson_products].where(url: link['href']).first
              unless edusson_products
                blog = get_blog(link['href'])
                begin
                  essay = {}
                  essay[:url] = link['href']
                  essay[:title] = link.text.strip
                  essay[:description] = blog[:description]
                  essay[:category] = blog[:categories]
                  essay[:page] = page_num
                  essay[:category_id] = category[:id]
                  essays << (essay)
                rescue RuntimeError
                  logger.warn "Runtime error with page #{link.href}"
                end
              end
            end
          end
          threads.each { |thr| thr.join }
        end
        essays.each do |essay|
          db[:edusson_products].insert(essay)
        end
      }
      db[:edusson_categories].where(id: category[:id]).update(is_processed: true)
    end

    def self.get_pages_range(category_url, category_id)
      last_edusson_categories = db[:edusson_products].where(category_id: category_id).order(Sequel.desc(:page)).first
      if last_edusson_categories
        first_page = last_edusson_categories[:page].to_i
      else
        first_page = 1
      end
      agent = Mechanize.new
      page = agent.get(category_url)
      last_page = 1
      page.links.each do |link|
        if link.dom_class == 'page-numbers'
          number_page = link.text.sub(',', '').to_i
          if number_page > last_page
            last_page = number_page
          end
        end
      end
      first_page..last_page
    end

    def self.parse_categories
      site_categories = db[:edusson_categories].first
      return if site_categories

      url = ''
      1.upto(3) do |i|
        url = "https://edusson.com/essay-examples/page/#{i}"
        html = URI.open(url).read
        doc = Nokogiri::HTML(html)
        doc.css('.popular-cat__block-title a').each do |category|
          category_name = category.text.strip
          link = category[:href]
          db[:edusson_categories].insert({ name: category_name, url: link })
        end
      end
    end

    def self.get_blog(link)
      page = URI.open(link)
      doc = Nokogiri::HTML.parse(page)
      category = doc.at_css('.breadcrumbs__item:nth-child(3)').text
      description = doc.css('.editor')
      description.css('.gradient-plagiarized').remove
      return {
        description: description.inner_html,
        categories: category
      }
    end

    def self.db
      O14::DB.get_db
    end

    def self.logger
      O14::ProjectLogger.get_logger 'INFO'
    end
  end
end
