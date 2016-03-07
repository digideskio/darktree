class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :front, null: false
      t.text :back, null: false
      t.text :memo
      t.integer :status, default: 0
      t.boolean :favorite, default: false
      t.timestamps null: false
    end
  end
end
