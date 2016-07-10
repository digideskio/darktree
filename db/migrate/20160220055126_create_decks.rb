class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name, null: false
      t.integer :deck_source_id, null: false
      t.timestamps null: false
    end
    add_index :decks, :name, unique: true
    add_index :decks, :deck_source_id, unique: true
  end
end
