require 'nokogiri'
require 'pry'

require_relative 'database'
require_relative 'models/pokemon'
require_relative 'scrapper/html_getter'

# I need to implement a solution like this to bypass their security service.
# https://stackoverflow.com/questions/33225947/can-a-website-detect-when-you-are-using-selenium-with-chromedriver
class PokemonScrapper
  POKEDEX_URL = 'https://www.pokemon.com'.freeze

  def initialize
    @db = Database.new('development.db').db
    @initial_url = "#{POKEDEX_URL}/el/pokedex/bulbasaur"
    @html_getter = Scrapper::HTMLGetter.new(strategy: 'firefox')
  end

  def scrape_pokemon
    begin
      html = html_getter.get_html(initial_url)

      binding.pry
      unless html.nil?
        insert_pokemon_into_db(html)
      end

      puts 'Sleeping'
      sleep(10)
      puts

      while url != initial_url
        html = html_getter.get_html(url)

        unless html.nil?
          insert_pokemon_into_db(html)
        end

        puts 'Sleeping'
        sleep(10)
        puts
      end
    rescue StandardError => error
      puts error.full_message
    ensure
      html_getter.close_driver
    end
  end

  private

  def insert_pokemon_into_db(html)
    parsed_page = Nokogiri::HTML(html)

    name = parsed_page.xpath('/html/body/div[4]/section[1]/div[2]/div/text()').text.strip
    pokedex_number = parsed_page.xpath('/html/body/div[4]/section[1]/div[2]/div/span').text
    types = parsed_page.xpath('/html/body/div[4]/section[3]/div[2]/div/div[3]/div[2]/div[1]/ul').text.strip.gsub(/\s+/, ',')
    hp = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[1]/ul/li[1]').first['data-value']
    attack = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[2]/ul/li[1]').first['data-value']
    defense = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[3]/ul/li[1]').first['data-value']
    special_attack = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[4]/ul/li[1]').first['data-value']
    special_defense = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[5]/ul/li[1]').first['data-value']
    speed = parsed_page.xpath('/html/body/div[4]/section[3]/div[1]/div[2]/ul/li[6]/ul/li[1]').first['data-value']
    abilities = parsed_page.xpath('/html/body/div[4]/section[3]/div[2]/div/div[3]/div[1]/div[2]/div/ul/li[2]/ul/li/a/span').text
    next_pokemon = parsed_page.xpath('/html/body/div[4]/section[1]/div[1]/a[2]').first['href']

    puts "Inserting #{name}"

    Pokemon.create(db, {
      name: name,
      pokedex_number: pokedex_number,
      types: types,
      abilities: abilities,
      hp: hp,
      attack: attack,
      defense: defense,
      special_attack: special_attack,
      special_defense: special_defense,
      speed: speed
    })

    @url = "#{POKEDEX_URL}#{next_pokemon}"
  end

  attr_reader :db, :initial_url, :url, :html_getter
end
