require "iconv"

module Horoscopes
  class Parser
    attr_accessor :allow_caching

    def cache_key
      "horoscopes_#{Time.now.strftime("%d.%m.%Y")}"
    end

    def cache_lifetime
      12.hours
    end

    def request_url
      "http://img.ignio.com/r/daily/index.xml"
    end

    def parse
      Horoscopes::Sign

      if self.allow_caching and cached_response = Rails.configuration.idfix.session.cache.get(self.cache_key)
        return cached_response
      else
        @signs = []

        request = Curl::Easy.new(self.request_url) do |curl|
          curl.headers["User-Agent"] = "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.0.8) Gecko/2009032609 Firefox/3.0.8"
          curl.verbose = true
        end

        begin
          request.perform

          doc = Hpricot(Iconv.iconv("utf-8", "windows-1251", request.body_str).to_s)

          tag_to_use = %w{yesterday today tomorrow tomorrow02}.find do |day|
            doc.at("date")[day] == Time.now.strftime("%d.%m.%Y")
          end

          (doc / tag_to_use).each do |tag|
            @signs << Sign.new(tag.parent.name, tag.innerText.strip)
          end
          
          if self.allow_caching
            Rails.configuration.idfix.session.cache.set(self.cache_key, @signs, self.cache_lifetime)
          end
        rescue
        end

        return @signs
      end
    end
  end
end