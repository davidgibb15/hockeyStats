class CreateCumulativeGames < ActiveRecord::Migration[5.2]
  def change
    create_table :cumulative_games do |t|
      t.references :player, foreign_key: true
      t.string :nhl_id
      t.date :date
      t.integer :goals
      t.integer :assists
      t.integer :hits
      t.integer :blocks
      t.integer :shots
      t.integer :points
      t.integer :pim
      t.integer :ppg
      t.integer :ppa
      t.integer :ppp
      t.integer :shg
      t.integer :sha
      t.integer :shp
      t.integer :gwg
      t.integer :otg
      t.integer :plus_minus
      t.integer :toi
      t.integer :mss
      t.integer :gva
      t.integer :tka
      t.integer :fow
      t.integer :fot
      t.integer :fol
      t.integer :gp

      t.timestamps
    end
  end
end
