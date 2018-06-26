class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.boolean :lw
      t.boolean :rw
      t.boolean :c
      t.boolean :d
      t.boolean :g
      t.references :team, foreign_key: true
      t.integer :age

      t.timestamps
    end
  end
end
