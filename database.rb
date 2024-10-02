require 'sequel'
require 'sqlite3'

class Database
  attr_reader :db

  def initialize(name = 'development.db')
    @db = Sequel.sqlite(name)
    create_table unless @db.table_exists?(:pokemons)
  end

  def drop_pokemons_table
    @db.drop_table :pokemons
  end

  private

  def create_table
    @db.create_table :pokemons do
      primary_key :id
      String :name
      String :pokedex_number
      String :types
      String :abilities
      Integer :hp
      Integer :attack
      Integer :defense
      Integer :special_attack
      Integer :special_defense
      Integer :speed
    end
  end
end
