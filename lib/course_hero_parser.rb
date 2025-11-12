require 'yaml'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'json'

module Parser
  class CourseHeroParser

    URL_PATH = 'https://www.coursehero.com'
    def self.run
      # @driver = O14::WebBrowser.get_driver

      logger.info 'started'
        
      loop do
 #       parse_categories
 #        category_url = get_next_category
        category_url = 'https://www.coursehero.com/sitemap/schools/1273-Walden-University/departments/297766-NURS/?__chid=9232d4f8-4ff5-4ad3-b81b-a597ecd80a31#/questions'
        logger.info category_url
        unless category_url
          sleep 30
          exit
        end
        parse_products(category_url)
      end
    rescue StandardError
      O14::ExceptionHandler.log_exception('course_hero_parser')
      sleep 30
    rescue Interrupt
      logger.info('The script was interrupted')
    end

    private



    def self.get_next_category
      return db[:course_hero_categories].where(is_processed: 0).first
    end

    def self.extract_department_id(url)
      match = url.match(/departments\/(\d+)-/)
      match ? match[1] : nil
    end

    def self.parse_products(category)
      get_pages_range(category).each { |page_num|
        logger.info page_num
        category_url = category
        agent = Mechanize.new
        agent.request_headers = {
          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:129.0) Gecko/20100101 Firefox/129.0",
          "Accept" => "*/*",
          "Accept-Language" => "ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3",
          "Accept-Encoding" => "gzip, deflate, zstd",
          "Referer" => "https://www.coursehero.com/sitemap/schools/1273-Walden-University/departments/486617-SOCW/",
          "X-NewRelic-ID" => "Ug8CUVVbGwIDUlVUBgkGVg==",
          "Sec-Fetch-Dest" => "empty",
          "Sec-Fetch-Mode" => "cors",
          "Sec-Fetch-Site" => "same-origin",
          "Connection" => "keep-alive",
          "Cookie" => "visid_incap_987752=APlDnwTQSdaG8309W+s587zktWYAAAAAQUIPAAAAAAAKqCFr3tLvh/36D1D3zMYK; incap_ses_1548_987752=DOpVbAmN90LnivkB7Zl7FbzktWYAAAAAl8jHI/FosMcDnmKsiDMuXQ==; nlbi_987752_2147483392=4NabdNOhE3YHg0X65Tz1lQAAAAA9duJn/ErkY+X3ewAmJeBD; incap_ses_1842_987752=JOc6fOXG5kDb2m1AZRmQGbzktWYAAAAAUIBEQdBOVnFVYCocLkQvXQ==; incap_ses_1700_987752=uReDK3QWxibRElGcHJ2XFxXttWYAAAAAqsRCBDJ7b9iQrMj9yOsuXw==; reese84=3:NDvYD2QVuPgALipHGENeXA==:jGRaEXE4dblbC8oM61z0daLujlXeFzDJeHl1iz1zWT2IIwT/Hgy9JO9nyEw81SWOYv68bmyX6V2DtNomcveE5xg/sdhCsXWcKTZFy50HLRXDO8Yoj/R+WFqupjVBde9cuVfnsrFGdiV/0o2WDYDKKFHPNlt3Q1Gh1nCu6sr17yOp9AMgr+QATbcCu/FlDCBhPE2RKN8FcCgkneSnulSBvVTUROKKOHqM2nDe4WIrfGmuIup0KC+GCts6MLFQLlqDaVsSgWalOa2PA6yM4gys3W0wdbgKecLG8NHIv+CAvMMzVdC8BFsA24cFq2xb7FZRA/dFYiQVO2dRcHiem+fEkvwI2qPIDdUyzhiVflCSYvdIvxjAk7n6O4QUPA3hQg2JoVOIPVGugh+0I/26vgS6TujB6sRLTXHtAwJ6d1cN/NZ4syxoCwtmuKLC7hFSIhfZ8xu2GnhD3QiBIe1pQsEJoPaAAs0Ks9oPO09eHrov0ZHoc0Q6xUfEss22fqvRR2d1:D3fzs6DRsyo0SZygFB11PYBi5K3awEOYugoGN8/4e4M=; incap_ses_7224_987752=JHhtVwoSRzXia9gM2M1AZG7ltWYAAAAAouuUeXiD2qDoAy5pZRmbFg==; incap_ses_482_987752=O76HTWYkcEiZ92AvlWiwBszqtWYAAAAALFFJF7wtPfMqdXyrwUL7iw==; PHPSESSID=efef107a-b534-4fc1-ae2f-7e915b78f517; root_session_id=efef107a-b534-4fc1-ae2f-7e915b78f517; device_view=full; nlbi_987752_2147483394=NouJCzrU/CvmS3VR5Tz1lQAAAABcRICn3/C5Dg49iaZQOXAH; incap_ses_237_987752=a/d9Du7Q4DpGuX0tX/5JA2/ltWYAAAAALMYqeZf3B5Bnb9JWakmohw==; incap_ses_1540_987752=YLpHIsA5k2GL4ZvT9y1fFXDltWYAAAAAUb5rEMwKk4S8bQkyHxtnPg==; nlbi_987752=Fu/wUmYtFy/2IwDW5Tz1lQAAAACtvWJSRTe+ZGDbkWRaQ0qJ; incap_ses_1349_987752=3YsGNDpb1UZSna+beJy4EnDltWYAAAAAO25F7nTtpMLidzpQCT87ng==; incap_ses_1816_987752=3OqtKMkCgDzreNGCgbozGc3qtWYAAAAAYGulF0Tri9O5CCI113L3sQ==; incap_ses_886_987752=5ivrW0/7jhmMKvX8brRLDMzqtWYAAAAASS+KdZdySLfwhoE0COcVrQ==; incap_ses_1843_987752=2qOCSONEB0GzlLv13KaTGXDltWYAAAAA4c7HLCM4rgIWOqSN/pgztA==; incap_ses_891_987752=T+VoDDpfoAdzPFjX5XddDMzqtWYAAAAATmuvRCyuEs1lrHqKWptddQ==; incap_ses_889_987752=P+iyUi9stTt5cgPg6lxWDMzqtWYAAAAAOLKFYV/S+4KsOo9ZVszpdA==; incap_ses_1538_987752=KVDSOe8bGHkeCpg++BJYFRLttWYAAAAAprWcR+EGCBvTvQrWlDn3ZQ==; incap_ses_1351_987752=gMthPF+sIHaXwUTgdbe/EszqtWYAAAAAylnKLOIqbgzF9ZLYI9HRSg==; incap_ses_483_987752=94yHJ55QWgZpSHIqFvazBszqtWYAAAAAvYR2HXM87fl9HzcaJ1Y4kg==; has_called_TBM=1; incap_ses_222_987752=SD9+e31qSXSJsl2B87MUA8zqtWYAAAAAgaaFFRPkLrkjkto6J9tSFA==; incap_ses_78_987752=VpF7PUBbPz8Nw8uHtBwVARPttWYAAAAAToJubTfOQyZ5xhg4eBfIjA==; incap_ses_1307_987752=AN7haKnEwkj1S6uWuGUjEnDltWYAAAAADLLlC8XosTKeN5kQju32tw==; incap_ses_1703_987752=2RW8BijxD3WKa1lsmEWiF83qtWYAAAAA4gdg71Pz/xf1P1u9Ib5kow==; incap_ses_1340_987752=n1S1V6opMDdnMRCEAqOYEnHltWYAAAAAGzNmANP79fSMlPIS7TS19Q==; incap_ses_269_987752=TPVfQXpmOhnTN1BqMa67A3LltWYAAAAAoJEiR/F6UIy7uF69o2TUMA==; OptanonConsent=isGpcEnabled=1&datestamp=Fri+Aug+09+2024+14%3A25%3A23+GMT%2B0400+(%D0%A1%D0%B0%D0%BC%D0%B0%D1%80%D1%81%D0%BA%D0%BE%D0%B5+%D1%81%D1%82%D0%B0%D0%BD%D0%B4%D0%B0%D1%80%D1%82%D0%BD%D0%BE%D0%B5+%D0%B2%D1%80%D0%B5%D0%BC%D1%8F)&version=202404.1.0&hosts=&GPPCookiesCount=1&groups=C0001%3A1%2CC0003%3A1%2CSPD_BG%3A0%2CC0004%3A0%2CC0002%3A0; OTGPPConsent=DBABLA~BVQVAAAABgA.YA; incap_ses_1346_987752=7l5wb36AVxtuDdWp/POtEnLltWYAAAAApD5thC6yohAmJf7jWamZBw==; incap_ses_890_987752=jQCfcGSRgnPPGUiGaepZDHPltWYAAAAAELn5Gr1c8ttfklszUz6BVQ==; incap_ses_892_987752=qvXvKErpwCL5R2Z6ZAVhDHPltWYAAAAAvC2gRcSM1pbg2WTUqI5Ewg==; incap_ses_157_987752=y9dCWE+ilXgmDwb7zcYtAnLltWYAAAAAlpDdLbkKaRy6lkcOR0XZSQ==; incap_ses_1813_987752=NuXpWyHgTRNIWjflBxIpGXPltWYAAAAAH0iFioEY0UR7V6hm7gnRnA==; incap_ses_887_987752=XfDRLPd5nwEkvg2d7UFPDHPltWYAAAAAhSvzDGaWJSVlXrlaa40VvQ==; incap_ses_8216_987752=w7lGW4MsfTJs20+PlhgFcnLltWYAAAAAmqa2GbsR+N3rYBvKTgiWVQ==; incap_ses_1845_987752=D6H5DPbO80LXbZbi18GaGXbstWYAAAAAuz2SxjZRgk90fQf54peNzg==; incap_ses_1252_987752=Jl8cCZIHMwM5RkgzfP9fEXPltWYAAAAAUMuGBKqnONfpCeSntxQSAw==; incap_ses_1342_987752=bq9gCnYufTr6hM3P/72fEnPltWYAAAAAiZiARhqWK8amN5pIVYO/Yw==; usprivacy=1---; incap_ses_1537_987752=JqYKRHJovDmTaReUeYVUFQbotWYAAAAASu7feHwKpk1twDMcabaSCg==; incap_ses_1546_987752=UgOZNK0JaG51sxpi7X50FXPltWYAAAAAE0oLCJvYhGA/53XdSC2cvw==; incap_ses_440_987752=Xu8LcBQWNmyuzrl30DEbBnTltWYAAAAAJ+l7QhFtWlWiUbLhoyY4Ug==; incap_ses_1844_987752=CVXcKAVTSCMBQIftVjSXGczqtWYAAAAAVzTYb7yJMTfyod8JPHvAeg==; incap_ses_1600_987752=YPaaCe5DEkqSQMUhpFc0FnTltWYAAAAAKu4ipZGKhhh2Hr/3dxRhRg==; OneTrustWPCCPAGoogleOptOut=true; incap_ses_1840_987752=ZDRiFmCUe33MK1SYXv6IGczqtWYAAAAAM+J7wQhc6Q43wsVOOvdISA==; incap_ses_1701_987752=Ny36Ur/W1gpd8RcjmyqbF6/ltWYAAAAA1TFvdh17HzukP9L0SjcgDw==; incap_ses_995_987752=+jQmSNtb9hepAbZmXfPODRbmtWYAAAAAw6YSskUl2b02/spSvhAZ+g==; incap_ses_1251_987752=Ryz8Qftbly9VAhWM/XFcERnmtWYAAAAAv5Z+Tnv1UOqStlNO3fMQIA==; incap_ses_1547_987752=vbSuGvc/sjO1Ndhbbgx4FRnmtWYAAAAAgVr3T9TTlMwmbK5oL9T2bQ==; incap_ses_484_987752=/EP3OMAgpUy0sDN4koO3BhnmtWYAAAAATkbv38errqtz+TDlKV7SMA==; incap_ses_1347_987752=VmCRfQYfTGp7wPRQe4GxEszqtWYAAAAAXUX+pHD/ybNWKOKfF+90xQ==; incap_ses_1841_987752=ifP4da+uQEDsVWWl34uMGRzmtWYAAAAAMwfD53cIGLKMpyQ8XN7s8w==; incap_ses_1345_987752=qo5oejjcsyicgAQIfmaqEiDmtWYAAAAAMEuZA05EEZYwolPsJYV8TQ==; incap_ses_1244_987752=O2WZPXFOenMNgPRUiZNDETPmtWYAAAAASNkfHEtK/fscrns2aTWqOA==; incap_ses_278_987752=dQ9AZac2pGJ6Dt2Ip6fbAzfmtWYAAAAAnCa8LQgYJivh32AXBT3QYg==; incap_ses_1246_987752=UYmJSwSSEwOBFsSehq5KETfmtWYAAAAAAZqMd9yYaPioid1cx/soTA==; incap_ses_1350_987752=wsULezHFi1mQ9xw89ym8EoHntWYAAAAA5WMn7I1wOVYwIYVAHcMYBg==; incap_ses_1286_987752=uDEsMqXn6WIOO+yuYMrYEYLntWYAAAAA1+GMtHWbGPYAYPK1g9HvjQ==; incap_ses_1544_987752=7SytBWAIuzqpavYX8GNtFYbntWYAAAAApDaO5x33Xh7+fxyoTm3ygw==; incap_ses_239_987752=oDTUXzsbOARseNzJVxlRA3fstWYAAAAAQjgcvrYW30BSFUn2ge4Ckw==; incap_ses_1541_987752=eVKmExdu8E6XJk0sdLtiFQfotWYAAAAAPKa9glmQj1yvUkMSarbv6w==; incap_ses_1536_987752=HIjXeHJA9lvN6XPv+vdQFZXotWYAAAAAdtDXvrJ+m/Lbk8/o62pUQw==; incap_ses_1532_987752=DfciZQ6soAP8Cl1eAMJCFbfptWYAAAAAxiG8Lo1DrLk0Q6K7mrozXQ==",
          "TE" => "trailers"
        }
        page = agent.get(category_url)
        if page.code == '200'
          department_id = extract_department_id(category_url)
          logger.info "Extracted Department ID: #{department_id}"
        end
        questions_and_answers = agent.get("https://www.coursehero.com/api/v1/department/#{department_id}/questions/?offset=0&limit=100&dataArray=true&cacheComposite=false")
        questions_and_answers = JSON.parse(questions_and_answers.body)
        questions_and_answers.each do |question|
          page = agent.get(URL_PATH + question['resource_url'])
          p page.body
          exit
        end
        essays = []
        while page_links.count > 0
          pages_threads = page_links.shift 8
          threads = []
          pages_threads.each do |page_to_fetch|
            threads << Thread.new(page_to_fetch) do |link|
              logger.info link['href']
              # course_hero_products = db[:course_hero_products].where(url: link['href']).first
              # unless course_hero_products
              #   blog = get_blog(link['href'])
              #   begin
              #     essay = {}
              #     essay[:url] = link['href']
              #     essay[:title] = blog[:title]
              #     essay[:description] = blog[:description]
              #     essay[:category] = blog[:categories]
              #     essay[:page] = page_num
              #     essay[:category_id] = category[:id]
              #     essays << (essay)
              #   rescue RuntimeError
              #     logger.warn "Runtime error with page #{link.href}"
              #   end
              # end
            end
          end
          threads.each { |thr| thr.join }
        end
        essays.each do |essay|
          db[:course_hero_products].insert(essay)
        end
        driver.navigate.to(page_template)
        begin
          wait = Selenium::WebDriver::Wait.new(timeout: 10) # Ждем максимум 10 секунд
          next_button = wait.until { driver.find_element(css: 'a.ch_number-pagination_button.next')}
          next_button.click

        rescue Selenium::WebDriver::Error::NoSuchElementError
          puts "No more pages to navigate."

        end
      }
      db[:course_hero_categories].where(id: category[:id]).update(is_processed: true)
    end

    def self.get_pages_range(category_url)
      # last_course_hero_categories = db[:course_hero_products].where(category_id: category_id).order(Sequel.desc(:page)).first
      # if last_course_hero_categories
      #   first_page = last_course_hero_categories[:page].to_i
      # else
      #   first_page = 1
      # end
      first_page = 1
      agent = Mechanize.new
      agent.request_headers = {
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:129.0) Gecko/20100101 Firefox/129.0",
        "Accept" => "*/*",
        "Accept-Language" => "ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3",
        "Accept-Encoding" => "gzip, deflate, zstd",
        "Referer" => "https://www.coursehero.com/sitemap/schools/1273-Walden-University/departments/486617-SOCW/",
        "X-NewRelic-ID" => "Ug8CUVVbGwIDUlVUBgkGVg==",
        "Sec-Fetch-Dest" => "empty",
        "Sec-Fetch-Mode" => "cors",
        "Sec-Fetch-Site" => "same-origin",
        "Connection" => "keep-alive",
        "Cookie" => "visid_incap_987752=APlDnwTQSdaG8309W+s587zktWYAAAAAQUIPAAAAAAAKqCFr3tLvh/36D1D3zMYK; incap_ses_1548_987752=DOpVbAmN90LnivkB7Zl7FbzktWYAAAAAl8jHI/FosMcDnmKsiDMuXQ==; nlbi_987752_2147483392=EvDyB/Gid0w2Qxu85Tz1lQAAAAAE/N0yu9LAC9/HLodcCSN3; incap_ses_1842_987752=JOc6fOXG5kDb2m1AZRmQGbzktWYAAAAAUIBEQdBOVnFVYCocLkQvXQ==; incap_ses_1700_987752=rNCOSCTAyUrx+CGcHJ2XF77ktWYAAAAAu1gJ+JlyS1nRTwkT3FUSVw==; reese84=3:Y1M1npc70Rdj4Nz6QImZRA==:xFqZMoAFoeu4aqrd73Q1x/7FYYfeizkG4uLmhq1qu2mSDH69BVO6krwNjAQaLimxUU8njkmjEorpJgsgZCYmbdsJZvOH4dr+7b4zKTiZOLs645IuQH6pyPhCRw0X2LuHKJQr4wEv6X68vlCCnvEaSxW0u9fohKjsa40lc4J5eFdZanKD2GLPnREFsehqst43ZHwMjC5cqpyoQhqIFah9fIfIN3FY1zjmihbLQ7j8RxjvXCvILcp89eIjWft23WJttmVaV11W599hHwh/iX9M0LoGLBjfiGlRXtPR3rvvYshT1hnQaiEOJa4YQ5gNLjPZQt1Nj0wxtDwYfaZQUqfrWAdOnlm3ynzHTf7hpiAPo3ay67rMpsl7HK4f2tAgqrXoH4V+GCaIywrGyX6odPf8p8TuOAU3qcK1DC3ZvFCXhf4zbuszIsHUgC779RdphC6WvC5GYxdL6fxChZ1is31RV3JlXpMvD944MUJ/9gRApZBDJ/+wP7kCym9YuaNHo25Z:Fn2nKUvURUoW/PatC1qVzWlXlvJfvf7wll5KTng+Ph0=; incap_ses_7224_987752=JHhtVwoSRzXia9gM2M1AZG7ltWYAAAAAouuUeXiD2qDoAy5pZRmbFg==; incap_ses_482_987752=DrL3Q5eI3XxmqVwvlWiwBsDktWYAAAAA55qKIl8+l16JeYiuNn6q2A==; PHPSESSID=efef107a-b534-4fc1-ae2f-7e915b78f517; root_session_id=efef107a-b534-4fc1-ae2f-7e915b78f517; device_view=full; nlbi_987752_2147483394=bWYSdSQtBy+uPsvT5Tz1lQAAAADNzKdT/O1CTIt4bStmVrSX; incap_ses_237_987752=a/d9Du7Q4DpGuX0tX/5JA2/ltWYAAAAALMYqeZf3B5Bnb9JWakmohw==; incap_ses_1540_987752=YLpHIsA5k2GL4ZvT9y1fFXDltWYAAAAAUb5rEMwKk4S8bQkyHxtnPg==; nlbi_987752=Fu/wUmYtFy/2IwDW5Tz1lQAAAACtvWJSRTe+ZGDbkWRaQ0qJ; incap_ses_1349_987752=3YsGNDpb1UZSna+beJy4EnDltWYAAAAAO25F7nTtpMLidzpQCT87ng==; incap_ses_1816_987752=jEENMKo1x0g+d8uCgbozGXDltWYAAAAAaKnk5tSZ75yRObLUqpKKkg==; incap_ses_886_987752=RHO6cFWFCGx9EvD8brRLDHDltWYAAAAA1qF5GXn9WJqOtl+AW1z9EQ==; incap_ses_1843_987752=2qOCSONEB0GzlLv13KaTGXDltWYAAAAA4c7HLCM4rgIWOqSN/pgztA==; incap_ses_891_987752=kZM9N/T98QuUDVDX5XddDHDltWYAAAAAP3BQOQEhb7kkegFlwhjWdQ==; incap_ses_889_987752=8SCmfONBZVr2JP/f6lxWDHDltWYAAAAAOZ2FgWq0vk9qxAp1dCnIaQ==; incap_ses_1538_987752=boFbHSlRCBEuKZE++BJYFXDltWYAAAAAbjKklhWMsl2ge93yQVGkWg==; incap_ses_1351_987752=6QYMLpmSMn+UW0Dgdbe/EnDltWYAAAAAXWXS6yFqNk7vXvMjnzcDxg==; incap_ses_483_987752=fF1nSKZ+DRg9rm8qFvazBnDltWYAAAAArIWvxzBGruCIkqPKdI8+RA==; has_called_TBM=1; incap_ses_222_987752=BFzpWk+jKEzNUlyB87MUA3DltWYAAAAAjTSRhJIDCz8ar6SwxajjHg==; incap_ses_78_987752=eR2FL/fqFW29ncSHtBwVAXHltWYAAAAAgc9WAHf7n9FQnnoRphiMJA==; incap_ses_1307_987752=AN7haKnEwkj1S6uWuGUjEnDltWYAAAAADLLlC8XosTKeN5kQju32tw==; incap_ses_1703_987752=yB1SYhdS1Hu8yVdsmEWiF3HltWYAAAAAqBti7sfCBD4wMZxM9LLeYw==; incap_ses_1340_987752=n1S1V6opMDdnMRCEAqOYEnHltWYAAAAAGzNmANP79fSMlPIS7TS19Q==; incap_ses_269_987752=TPVfQXpmOhnTN1BqMa67A3LltWYAAAAAoJEiR/F6UIy7uF69o2TUMA==; OptanonConsent=isGpcEnabled=1&datestamp=Fri+Aug+09+2024+13%3A49%3A41+GMT%2B0400+(%D0%A1%D0%B0%D0%BC%D0%B0%D1%80%D1%81%D0%BA%D0%BE%D0%B5+%D1%81%D1%82%D0%B0%D0%BD%D0%B4%D0%B0%D1%80%D1%82%D0%BD%D0%BE%D0%B5+%D0%B2%D1%80%D0%B5%D0%BC%D1%8F)&version=202404.1.0&hosts=&GPPCookiesCount=1; OTGPPConsent=DBABLA~BVQVAAAABgA.YA; incap_ses_1346_987752=7l5wb36AVxtuDdWp/POtEnLltWYAAAAApD5thC6yohAmJf7jWamZBw==; incap_ses_890_987752=jQCfcGSRgnPPGUiGaepZDHPltWYAAAAAELn5Gr1c8ttfklszUz6BVQ==; incap_ses_892_987752=qvXvKErpwCL5R2Z6ZAVhDHPltWYAAAAAvC2gRcSM1pbg2WTUqI5Ewg==; incap_ses_157_987752=y9dCWE+ilXgmDwb7zcYtAnLltWYAAAAAlpDdLbkKaRy6lkcOR0XZSQ==; incap_ses_1813_987752=NuXpWyHgTRNIWjflBxIpGXPltWYAAAAAH0iFioEY0UR7V6hm7gnRnA==; incap_ses_887_987752=XfDRLPd5nwEkvg2d7UFPDHPltWYAAAAAhSvzDGaWJSVlXrlaa40VvQ==; incap_ses_8216_987752=w7lGW4MsfTJs20+PlhgFcnLltWYAAAAAmqa2GbsR+N3rYBvKTgiWVQ==; incap_ses_1845_987752=yZBEdrptymiebX3i18GaGXLltWYAAAAAcsUN4cXIuCKNDrWnnaXD3g==; incap_ses_1252_987752=Jl8cCZIHMwM5RkgzfP9fEXPltWYAAAAAUMuGBKqnONfpCeSntxQSAw==; incap_ses_1342_987752=bq9gCnYufTr6hM3P/72fEnPltWYAAAAAiZiARhqWK8amN5pIVYO/Yw==; usprivacy=1---; incap_ses_1537_987752=WxOXZtVWr2RswhaUeYVUFXPltWYAAAAAh9TLYqVj7smjyeC5WAaWFg==; incap_ses_1546_987752=UgOZNK0JaG51sxpi7X50FXPltWYAAAAAE0oLCJvYhGA/53XdSC2cvw==; incap_ses_440_987752=Xu8LcBQWNmyuzrl30DEbBnTltWYAAAAAJ+l7QhFtWlWiUbLhoyY4Ug==; incap_ses_1844_987752=ued4eXadDChxMnTtVjSXGXTltWYAAAAA6DJ9T22IPTq4jIGxnsIefA==; incap_ses_1600_987752=YPaaCe5DEkqSQMUhpFc0FnTltWYAAAAAKu4ipZGKhhh2Hr/3dxRhRg==; OneTrustWPCCPAGoogleOptOut=true; incap_ses_1840_987752=y0ZRVuAFLiCKNT+YXv6IGX3ltWYAAAAA2Glpx+7g5U4sYyLMslw+MQ==; incap_ses_1701_987752=Ny36Ur/W1gpd8RcjmyqbF6/ltWYAAAAA1TFvdh17HzukP9L0SjcgDw==; incap_ses_995_987752=+jQmSNtb9hepAbZmXfPODRbmtWYAAAAAw6YSskUl2b02/spSvhAZ+g==; incap_ses_1251_987752=Ryz8Qftbly9VAhWM/XFcERnmtWYAAAAAv5Z+Tnv1UOqStlNO3fMQIA==; incap_ses_1547_987752=vbSuGvc/sjO1Ndhbbgx4FRnmtWYAAAAAgVr3T9TTlMwmbK5oL9T2bQ==; incap_ses_484_987752=/EP3OMAgpUy0sDN4koO3BhnmtWYAAAAATkbv38errqtz+TDlKV7SMA==; incap_ses_1347_987752=dyieRV0R3F8/hfFQe4GxEhzmtWYAAAAAGv2fkZ+50N/4/VqCeHte2w==; incap_ses_1841_987752=ifP4da+uQEDsVWWl34uMGRzmtWYAAAAAMwfD53cIGLKMpyQ8XN7s8w==; incap_ses_1345_987752=qo5oejjcsyicgAQIfmaqEiDmtWYAAAAAMEuZA05EEZYwolPsJYV8TQ==; incap_ses_1244_987752=O2WZPXFOenMNgPRUiZNDETPmtWYAAAAASNkfHEtK/fscrns2aTWqOA==",
        "TE" => "trailers"}

      logger.info category_url
      page = agent.get(category_url)
      last_page = 1
      element = page.at('h3[data-ng-hide="searchResources"]')

      if element
        text = element.text.strip
        numbers = text.scan(/\d+/)

        if numbers.size >= 3
          second_number = numbers[1].to_i
          third_number = numbers[2].to_i
        end
        first_page = second_number/8.0
        last_page = (third_number/8.0).ceil
      end
      first_page..last_page
    end

#    def self.parse_categories
#      site_categories = db[:course_hero_categories].first
#      return if site_categories
#
#      url = 'https://ivypanda.com/essays/'
#      html = URI.open(url).read
#      doc = Nokogiri::HTML(html)
#      doc.css('.ip-most-popular-subjects .ip-most-popular-subjects__title > a').each do |category|
#        category_name = category.text.strip
#        link = category[:href]
#        db[:ivy_panda_categories].insert({ name: category_name, url: link })
#      end
#    end

    def self.get_blog(link)
      categories = nil
      agent = Mechanize.new
      page = agent.get(link)
      title_el = page.at('h1[data-testid="granite-heading"]')
      elements = page.search('a[data-cha-target-name] div[aria-label] span')
      elements.each do |element|
        categories = element.text.strip
      end
      paragraphs = page.search('.qna-content.ck-content.tw-mt-8 p')
      text_content = paragraphs.map { |p| p.text.strip }.join("\n")
      return {
        title: title_el,
        description: text_content,
        categories: categories
        
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
