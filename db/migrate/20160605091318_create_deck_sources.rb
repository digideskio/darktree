class CreateDeckSources < ActiveRecord::Migration
  def change
    create_table :deck_sources do |t|
      t.string :deck_name, null: false
      t.string :url, null: false
      t.timestamps null: false
    end
    add_index :deck_sources, :deck_name, unique: true
  end
end
