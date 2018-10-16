class AddYahooIdToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :yahoo_id, :string
  end
end
