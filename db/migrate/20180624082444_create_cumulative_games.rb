class CreateCumulativeGames < ActiveRecord::Migration[5.2]
  def change
    create_table :cumulative_games do |t|
      t.references :player, foreign_key: true
      t.date :date
      t.boolean :home
      t.references :team, foreign_key: true
      t.references :opponent_team
      t.integer :goals
      t.integer :assists
      t.integer :hits
      t.integer :blocks
      t.integer :shots
      t.integer :pim
      t.integer :ppg
      t.integer :ppa
      t.integer :shg
      t.integer :sha
      t.integer :gwg
      t.integer :otg
      t.integer :plus_minus
      t.integer :toi
      t.integer :mss
      t.integer :gva
      t.integer :tka
      t.integer :fow
      t.integer :fot

      t.timestamps
    end
  end
end
