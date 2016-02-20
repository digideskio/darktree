class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :head, null: false
      t.string :tail, null: false
      t.text :memo
      t.integer :check, default: 0
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
