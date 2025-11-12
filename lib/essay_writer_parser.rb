require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mysql2'

module Parser
  class EssayWriterParser

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
      return db[:essay_writer_categories].where(is_processed: 0).first
    end

    def self.parse_products(category)
      get_pages_range(category[:url], category[:id]).each { |page_num|
        logger.info page_num
        page_template = "#{category[:url]}/page/#{page_num}"
        agent = Mechanize.new
        page_with_blogs = agent.get(page_template)
        page_links = page_with_blogs.search('.subject__title a').to_a
        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 10
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              logger.info link['href']
              essay_writer_products = db[:essay_writer_products].where(url: link['href']).first
              unless essay_writer_products
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
          db[:essay_writer_products].insert(essay)
        end
      }
      db[:essay_writer_categories].where(id: category[:id]).update(is_processed: true)
    end

    def self.get_pages_range(category_url, category_id)
      last_essay_writer_categories = db[:essay_writer_products].where(category_id: category_id).order(Sequel.desc(:page)).first
      if last_essay_writer_categories
        first_page = last_essay_writer_categories[:page].to_i
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
      site_categories = db[:essay_writer_categories].first
      return if site_categories

      1.upto(3) do |i|
        url = 'https://essaywriter.org/subjects/'
        html = URI.open(url).read
        doc = Nokogiri::HTML(html)
        doc.css('.all-subjects__name a').each do |category|
          category_name = category.text.strip
          link = category[:href]
          db[:essay_writer_categories].insert({ name: category_name, url: link })
        end
      end
    end

    def self.get_blog(link)
      page = URI.open(link)
      doc = Nokogiri::HTML.parse(page)
      categories_elements = doc.css('tr.subject-single__top-item td a')
      categories = categories_elements.map { |link| link.text }
      description = doc.css('.subject-single__content')
      description.css('.email-collector').remove
      return {
        description: description.inner_html,
        categories: categories.join("\n")
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
