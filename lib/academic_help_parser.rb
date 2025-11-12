require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mysql2'

module Parser
  class AcademicHelpParser

    def self.run
      logger.info 'started'
      loop do
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
      return db[:academic_help_categories].where(is_processed: 0).first
    end

    def self.parse_products(category)
      get_pages_range(category[:url], category[:id]).each { |page_num|
        logger.info page_num
        page_template = "#{category[:url]}page/#{page_num}"
        agent = Mechanize.new
        page_with_blogs = agent.get(page_template)
        page_links = page_with_blogs.search('h3.entry-title a').to_a
        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 10
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              logger.info link['href']
              edubirdie_products = db[:academic_help_products].where(url: link['href']).first
              unless edubirdie_products
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
          db[:academic_help_products].insert(essay)
        end
      }
      db[:academic_help_categories].where(id: category[:id]).update(is_processed: true)
    end

    def self.get_pages_range(category_url, category_id)
      last_academic_help_categories = db[:academic_help_products].where(category_id: category_id).order(Sequel.desc(:page)).first
      if last_academic_help_categories
        first_page = last_academic_help_categories[:page].to_i
      else
        first_page = 1
      end
      agent = Mechanize.new
      page = agent.get(category_url)
      pages_element = page.search('.pages').first.text
      last_page = pages_element.split(' ')[3].to_i
      first_page..last_page
    end

    def self.get_blog(link)
      page = URI.open(link)
      doc = Nokogiri::HTML.parse(page)
      category = doc.css('.breadcrumbs a[data-wpel-link="internal"]')[2].text
      description = doc.css('div.post-content')
      description.css('.traffic-block').remove
      description.css('#related-post-tags').remove
      description.css('.post-tags').remove
      description.css('#subscription_form').remove
      description.css('.subscription-addition-info').remove
      description.css('.comments').remove
      description.css('.single-related-posts').remove
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
