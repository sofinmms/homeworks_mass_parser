require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mysql2'

module Parser
  class AssignmentDeskParser

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
      return db[:assignment_desk_categories].where(is_processed: 0).first
    end

    def self.parse_products(category)
      get_pages_range(category[:id]).each{ |page_num|
        logger.info page_num
        page_template = "#{category[:url]}?page=#{page_num}"
        agent = Mechanize.new
        page_with_blogs = agent.get(page_template)
        page_links = page_with_blogs.search('.sample_page_ajax #allsamples a.title').to_a
        break if page_links.empty?

        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 10
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              url = "https://www.assignmentdesk.co.uk#{link['href']}"
              logger.info url
              assignment_desk_products = db[:assignment_desk_products].where(url: url).first
              unless assignment_desk_products
                blog = get_blog(url)
                begin
                  essay = {}
                  essay[:url] = url
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
          db[:assignment_desk_products].insert(essay)
        end
      }
      db[:assignment_desk_categories].where(id: category[:id]).update(is_processed: true)
    end

    def self.get_pages_range(category_id)
      last_academic_help_categories = db[:assignment_desk_products].where(category_id: category_id).order(Sequel.desc(:page)).first
      if last_academic_help_categories
        first_page = last_academic_help_categories[:page].to_i
      else
        first_page = 1
      end
      first_page..1000
    end

    def self.parse_categories
      site_categories = db[:assignment_desk_categories].first
      return if site_categories

      url = 'https://www.assignmentdesk.co.uk/free-samples'
      html = URI.open(url).read
      doc = Nokogiri::HTML(html)
      doc.css('.boxs a.comman_a_tag').each do |category|
        category_name = category.text.strip
        link = "https://www.assignmentdesk.co.uk#{category[:href]}"
        db[:assignment_desk_categories].insert({ name: category_name, url: link })
      end
    end

    def self.get_blog(link)
      page = URI.open(link)
      doc = Nokogiri::HTML.parse(page)
      category = doc.css('.tablePractice').at('li:contains("Paper Type:")').text.split(':').last.strip rescue nil
      description = doc.css('#content')
      description.css('.content-table').remove
      description.css('.content-overlay').remove
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
