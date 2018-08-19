class CumulativeGamesController < ApplicationController
  def search
  	category_to_placement= {"goals": 0, "assists": 1, }
  	@categories = params["categories"]
  	if @categories.nil? || @categories.length == 0
  		@categories = ["goals", "assists", "shots", "blocks", "hits", "pim", "ppp", "gwg", "plus_minus"]
  	end
  	@weights = weights_hash
  	
  	min_games = 5

  	@stats=CumulativeGame.get_normalized_average_stats(@categories, @weights, 82, min_games)
  end

  private

  def get_category_weight_placement(category)
  	cats = ["goals", "assists", "points", "shots", "blocks", "hits", "pim", "ppg", "ppa", "ppp", "shg", "sha", "shp","gwg", "plus_minus", "toi", "fow", "fol", "fot", "gva", "tka"]
  	cats.index(category)
  end

  def weights_hash
  	if params["weights"]
	  	weights = @categories.map do |category|
	  		weight = params["weights"][get_category_weight_placement(category)]
	  		weight = weight == '' ? 1 : weight.to_f
	  	 	[category, weight]
	  	end.to_h
	else
		weights = @categories.map do |category|
	  	 	[category, 1]
	  	end.to_h		
	end
	weights
  end

end
