class CreateCardDecks < ActiveRecord::Migration
  def change
    create_table :card_decks do |t|
      t.belongs_to :card
      t.belongs_to :deck
      t.timestamps null: false
    end
    add_index :card_decks, [:card_id, :deck_id], unique: true
  end
end
