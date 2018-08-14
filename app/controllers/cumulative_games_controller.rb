class CumulativeGamesController < ApplicationController
  def search
  	@categories = params["categories"]
  	puts @categories
  	if @categories.nil? || @categories.length == 0
  		@categories = ["goals", "assists", "shots", "blocks", "hits", "pim", "ppp", "gwg", "plus_minus"]
  	end
  	@stats=CumulativeGame.get_normalized_stats(@categories,82)
  end
end
