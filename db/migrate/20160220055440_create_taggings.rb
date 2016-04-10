class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :card
      t.belongs_to :tag
      t.timestamps null: false
    end
    add_index :taggings, [:card_id, :tag_id], unique: true
  end
end
