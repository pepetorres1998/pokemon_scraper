require 'selenium-webdriver'

module Scrapper
  module Strategy
    class Firefox
      def initialize
        options = Selenium::WebDriver::Firefox::Options.new
        # options.headless! # Ejecutar en modo headless (sin interfaz gráfica)

        # Inicia el navegador Firefox con Selenium
        @driver = Selenium::WebDriver.for(:firefox, options: options)
      end

      def get_html(url)
        driver.navigate.to(url)

        driver.page_source
      end

      def close_driver
        driver.quit
      end

      private

      attr_reader :driver
    end
  end
end
