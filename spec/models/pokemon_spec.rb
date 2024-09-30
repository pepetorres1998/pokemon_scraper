require_relative '../../models/pokemon'

RSpec.describe Pokemon do
  describe '.create', uses_database: true do
    let(:db) { Database.new('test.db').db }

    it 'creates a pokemon' do
      expect do
        described_class.create(
          db,
          {
            name: 'Bulbasur',
            pokedex_number: 1,
            types: 'grass',
            abilities: 'idk',
            hp: 60,
            attack: 40,
            defense: 40,
            special_attack: 40,
            special_defense: 40,
            speed: 20
          }
        )
      end.to change { Pokemon.count(db) }.by(1)
    end
  end

  describe 'to_json' do
    it 'displays an existing pokemon as json' do
      pending 'Need to write this logic'
      expect(pokemon.to_json).to eq({name: 'Bulbasor', pokedex_number: 1})
    end
  end
end
