class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :decks, :name, unique: true
  end
end
