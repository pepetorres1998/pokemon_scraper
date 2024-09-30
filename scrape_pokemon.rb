require 'sequel'

class PokemonScrapper
  POKEDEX_URL = 'https://www.pokemon.com/el/pokedex/'.freeze

  def initialize
    @db = Database.new
  end

  private
end
