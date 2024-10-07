require_relative 'strategy/firefox'
require_relative 'strategy/httparty'

module Scrapper
  class HTMLGetter
    def initialize(strategy: 'httparty')
      @strategy = set_strategy(strategy)
    end

    def get_html(url)
      return strategy.get_html(url) unless strategy.nil?

      raise StandardError, "Strategy unknown"
    end

    def close_driver
      strategy.close_driver
    end

    private

    attr_reader :strategy

    def set_strategy(strategy)
      case strategy
      when 'httparty'
        Scrapper::Strategy::HTTParty.new
      when 'firefox'
        Scrapper::Strategy::Firefox.new
      else
        nil
      end
    end
  end
end
