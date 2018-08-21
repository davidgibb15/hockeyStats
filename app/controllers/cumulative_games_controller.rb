class CumulativeGamesController < ApplicationController
  def search
  	category_to_placement= {"goals": 0, "assists": 1, }
  	@categories = params["categories"]
  	if @categories.nil? || @categories.length == 0
  		@categories = ["goals", "assists", "shots", "blocks", "hits", "pim", "ppp", "gwg", "plus_minus"]
  	end
  	@weights = weights_hash
  	
  	min_games = 5

    filters = {}
    unless (params["data1"].nil? or params["data2"].nil?) or (params["data1"] == "" and params["data2"] == "")
      min_age = 
        if params["data1"] == ""
          18
        else
          params["data1"].to_i
        end
      max_age = 
        if params["data2"] == ""
          50
        else
          params["data2"].to_i
        end
      filters[:age] = [min_age, max_age]
    end

    unless (params["data3"].nil? or params["data4"].nil?) or (params["data3"] == "" and params["data4"] == "")
      min_years = 
        if params["data3"] == ""
          0
        else
          params["data3"].to_i
        end
      max_years = 
        if params["data4"] == ""
          27
        else
          params["data4"].to_i
        end
      filters[:years_in_league] = [min_years, max_years]
    end

    unless params["positions"].nil?
      filters[:positions] = []
      params["positions"].each do |position|
        filters[:positions] << position
      end
    end
    puts filters
    puts '_--------------------------'

  	@stats=CumulativeGame.get_normalized_average_stats(@categories, @weights, 82, min_games, filters)
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
