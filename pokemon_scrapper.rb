require 'httparty'
require 'nokogiri'
require 'pry'

require_relative 'database'
require_relative 'models/pokemon'

class PokemonScrapper
  POKEDEX_URL = 'https://www.pokemon.com'.freeze

  def initialize
    @db = Database.new('development.db').db
    @initial_url = "#{POKEDEX_URL}/el/pokedex/bulbasur"
  end

  def scrape_pokemon
    response = HTTParty.get(initial_url, headers: request_headers)

    if response.success?
      parsed_page = Nokogiri::HTML(response.body)
    end

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

    puts 'Sleeping'
    sleep(10)
    puts

    while url != initial_url
      response = HTTParty.get(url, headers: request_headers)

      if response.success?
        parsed_page = Nokogiri::HTML(response.body)
      end

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
        hp: hp,
        attack: attack,
        defense: defense,
        special_attack: special_attack,
        special_defense: special_defense,
        speed: speed
      })

      @url = "#{POKEDEX_URL}#{next_pokemon}"

      puts 'Sleeping'
      sleep(10)
      puts
    end
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

  attr_reader :db, :initial_url, :url
end

ps = PokemonScrapper.new

ps.scrape_pokemon
