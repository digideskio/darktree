class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :front, null: false
      t.text :back, null: false
      t.integer :check_count, default: 0
      t.boolean :status, default: false
      t.boolean :favorite, default: false
      t.timestamps null: false
    end
  end
end
