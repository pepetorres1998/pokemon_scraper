require 'httparty'

module Scrapper
  module Strategy
    class HTTParty
      def get_html(url)
        response = HTTParty.get(url, headers: request_headers)

        response.body
      end

      private

      def request_headers
        @request_headers ||= {
          "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
          "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
          "Accept-Language" => "en-US,en;q=0.9",
          "Connection" => "keep-alive",
          "Upgrade-Insecure-Requests" => "1"
        }
      end
    end
  end
end
