require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mysql2'

module Parser
  class Example
    NURSING = 'Nursing'

    @db = O14::DB.get_db

    def self.run(first_page = 1)
      logger.info 'started'
      get_blog('https://onlinenursingessays.com/nurs-8002c-blog-learning-online/')
      agent = Mechanize.new
      get_blog_links(agent, first_page)
    end

    private

    def self.get_pages_range(agent, first_page)
      page = agent.get('https://onlinenursingessays.com/blog/')
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
    

    def self.get_blog_links(agent, first_page)
      links_array = []
      for page_num in get_pages_range(agent, first_page)
        logger.info page_num
        page_template = "https://onlinenursingessays.com/blog/page/#{page_num}"
        page_with_blogs = agent.get(page_template)
        page_links = page_with_blogs.links.select{|_e| _e.rel[0] == 'bookmark'}
        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 10
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              begin
                essay = {}
                essay[:url] = link.href
                essay[:title] = link.text
                essay[:description] = get_blog(link.href)
                essay[:category] = NURSING
                essays.push(essay)
              rescue RuntimeError
                logger.warn "Runtime error with page #{link.href}"
              end
            end
          end
          threads.each {|thr| thr.join }
        end
        essays.each do |essay|
          exist_post = @db[:onlinenursingessays].where(:url => essay[:url]).first
          if exist_post.nil?
            @db[:onlinenursingessays].insert(essay)
          end
        end

      end
    end

    def self.get_blog(link)
      page = URI.open(link)
      doc = Nokogiri::HTML.parse(page)
      tr = doc.at('article')
      tr.css('div.wp-block-kadence-rowlayout').remove
      tr.inner_html
    end

    def self.db
      O14::DB.get_db
    end

    def self.logger
      O14::ProjectLogger.get_logger
    end
  end
end
