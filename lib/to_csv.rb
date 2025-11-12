require 'csv'

module Parser
  class ToCSV
    attr_writer :db

    EXPORT_ROWS = 1000
    CSV_TITLE = %w[post_status post_type post_content post_title post_category]

    def initialize(table_name)
			@table_name = table_name
      @export_count = 0
      @rows_in_csv = 0
      @table_categories = "#{table_name}_categories"
      @table_products = "#{table_name}_products"
      @files_counter = { :files => 0, :rows => 0 }
    end

    def export_table
      O14::DB.get_db[@table_products.to_sym].join(@table_categories.to_sym, id: :category_id).distinct.all.each do |row|
        process_post(clean_page(row))
      end
    end

    protected

    def add_title_to_csv filename
      headers = CSV.open(File.expand_path('../../scraped_files/' + filename, __FILE__), 'r') { |csv| csv.first } rescue []
      if headers != CSV_TITLE
        CSV.open(File.expand_path('../../scraped_files/' + filename, __FILE__), "ab") do |csv|
          csv << CSV_TITLE
        end
      end
    end

    def clean_page(row)
      html_content = row.gsub(/<p>Follow us on.+?<\/p>/m, '').gsub(/<div class="traffic-block".*?<\/div>/m, '')
      doc = Nokogiri::HTML(html_content)
      doc.css('.whatsapp_strip').remove
      doc.css('.aside>.d-print-none').remove
      doc.at_css('.calculate-estimate').remove
      doc.to_html
    end

    def add_row_to_csv(data)
      if @files_counter[:rows] == 1000
        @files_counter[:files] += 1
        @files_counter[:rows] = 0
      end
      filename = "#{@table_name}-#{@files_counter[:files] * 1000 + 1}-#{(@files_counter[:files] + 1) * 1000}.csv"
      if @files_counter[:rows] == 0
        add_title_to_csv filename
      end
      CSV.open(File.expand_path('../../scraped_files/' + filename, __FILE__), "ab") do |csv|
        csv << data
      end
      @files_counter[:rows] += 1
    end


    def process_post post_row
      unless post_row[:title].nil?
        data = {}
        data[:url] = post_row[:url]
        data[:title] = post_row[:title].strip if post_row[:title]
        if post_row[:category] && !post_row[:category].empty?
          data[:category] = post_row[:category].split("\n").map{|_e| _e.strip}.reject{|_e| _e.empty?}.first.strip rescue ''
        else
          data[:category] = ''
        end
        if data[:category].empty?
          data[:category] = post_row[:name].strip rescue ''
        end
        data[:description] = post_row[:description].strip if post_row[:description]
        data[:status] = 'publish'
        prepared_data = []
        prepared_data << data[:status]
        prepared_data << 'post'
        prepared_data << data[:description]
        prepared_data << data[:title]
        prepared_data << data[:category]
        add_row_to_csv(prepared_data)
      end
    end


  end
end

