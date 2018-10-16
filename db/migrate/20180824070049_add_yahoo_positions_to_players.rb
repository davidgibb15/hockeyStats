class AddYahooPositionsToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :yahoo_lw, :boolean
    add_column :players, :yahoo_rw, :boolean
    add_column :players, :yahoo_c, :boolean
    add_column :players, :yahoo_d, :boolean
    add_column :players, :yahoo_g, :boolean
  end
end
