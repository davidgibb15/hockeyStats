class CumulativeGamesController < ApplicationController
  def index
  	@categories = ["goals"]
  	@stats=CumulativeGame.get_normalized_stats(@categories,@numGames.to_i)
  end
end
