class Api::V1::SearchController < ApplicationController
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

    unless params["yahoo_positions"].nil?
      filters[:yahoo_positions] = []
      params["yahoo_positions"].each do |position|
        filters[:yahoo_positions] << position.downcase
      end
    end
    if params['ignore'] && params['ignore']['player_id'].length > 1
      params['ignore']['player_id'].delete_at(0)
      filters[:exclude_players] = params['ignore']['player_id']
    end
    num_games = (params.has_key?("num_games") and params["num_games"] != "") ? params["num_games"].to_i : 82
    #filters[:exclude_players] = ignorable
    puts 'hiiiii'
    puts filters
    @stats = if (params.has_key?('lookup_type') && params['lookup_type'] == 'Average')
  	  CumulativeGame.get_normalized_average_stats(@categories, @weights, num_games, min_games, filters)
    else
      CumulativeGame.get_normalized_stats(@categories, @weights, num_games, min_games, filters)
    end
    render json: @stats
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
  def ignorable
    [139, 350, 28, 399, 357, 59, 529, 373, 623, 565, 44, 159, 388, 412, 113, 78, 510, 424, 381, 191, 632, 512, 553, 476, 216, 385, 569, 102, 342, 484, 88, 372, 233, 599, 441, 183, 199, 384, 651, 224, 62, 215, 238, 50, 178, 40, 213, 18, 21, 23, 498, 212, 302, 225, 131, 135, 386, 24, 405, 7, 103, 283, 110, 165, 25, 500, 6, 221, 168, 665, 273, 506, 175, 255, 541, 288, 85, 355, 681, 436, 624, 593, 416, 121, 181, 483, 409, 702, 94, 413, 605, 64, 56, 791, 307, 299, 109, 297, 394, 73, 598, 492, 521, 16, 717, 420, 456, 590, 546, 317, 260, 458, 323, 402, 107, 557, 261, 145, 387, 363, 418, 282, 187, 210, 831, 99, 627, 435, 375, 105, 545, 407, 443, 326, 639, 337, 731, 517, 617, 36, 300, 267, 208, 232, 244, 177, 207, 411, 98, 634, 576, 57, 89, 353, 345, 148, 68, 333, 306, 171, 703, 80, 489, 596, 119, 142, 595, 13, 219, 222, 60, 476, 343, 354, 539, 618, 439, 674, 77, 516, 447, 494, 258] 
  end
end
