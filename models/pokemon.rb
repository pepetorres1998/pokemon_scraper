require_relative '../database'

class Pokemon
  def initialize
    @db = Database.new
  end

  def self.create(db, data = {})
    db[:pokemons].insert(data)
  end

  def self.count(db)
    db[:pokemons].count
  end
end
