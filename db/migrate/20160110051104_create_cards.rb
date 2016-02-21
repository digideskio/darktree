class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :head, null: false
      t.text :tail, null: false
      t.text :memo
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
