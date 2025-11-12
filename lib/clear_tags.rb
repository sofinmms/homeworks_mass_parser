require 'nokogiri'

module Parser
  class ClearTags
    NURSING = 'Nursing'
    @db = O14::DB.get_db

    def self.run
      all_content = @db[:onlinenursingessays].all
      all_content.each do |row|
        page = row[:description]
        doc = Nokogiri::HTML.parse(page)
        doc.xpath('.//strong[contains(text(),"Click here to ORDER an A++")]/../..').remove
        doc.css('a').remove
        good_page = process_description(doc.inner_html)
        add_in_db(row, good_page)
      end
    end

    protected

    def self.add_in_db(row, doc)
      essay = {}
      essay[:url] = row[:url]
      essay[:title] = row[:title]
      essay[:description] = doc
      essay[:category] = NURSING
      exist_post = @db[:onlinenursingessays_without_tags].where(:url => essay[:url]).first
      if exist_post.nil?
        @db[:onlinenursingessays_without_tags].insert(essay)
      end
    end

    def self.process_description(inner_html_text)
      inner_html_text = inner_html_text.gsub(/<\/p>/, '###hah2aha###</p>')
      inner_html_text = inner_html_text.gsub(/<\/tr>/, '###hah2aha###</tr>')
      inner_html_text = inner_html_text.gsub(/<\/h1>/, '###hah2aha###</h1>')
      inner_html_text = inner_html_text.gsub(/<\/h2>/, '###hah2aha###</h2>')
      inner_html_text = inner_html_text.gsub(/<\/h3>/, '###hah2aha###</h3>')
      inner_html_text = inner_html_text.gsub(/<\/th>/, '###hah2aha###</th>')
      inner_html_text = inner_html_text.gsub(/<\/td>/, '###hah2aha###</td>')
      inner = inner_html_text.gsub(/<\/li>/, '###hah2aha###</li>')
      text_el = Nokogiri::HTML.parse(inner)
      descr = text_el.text.gsub(/###hah2aha###/, "\n").gsub(/\n+/, "\n")
      descr.gsub(/^[\p{Z}\n\t\r]+/, '').strip
    end

    def self.db
      O14::DB.get_db
    end

    def self.logger
      O14::ProjectLogger.get_logger
    end
  end
end
