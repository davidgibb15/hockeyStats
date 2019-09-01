class CumulativeGamesController < ApplicationController
  def search
    categories = params["categories"].blank? ? default_categories : params["categories"]
  	min_games = 5

    filters = build_filters

    if params['ignore'] && params['ignore']['player_id'].length > 1
      params['ignore']['player_id'].delete_at(0)
      filters[:exclude_players] = params['ignore']['player_id']
    end
    num_games = (params.has_key?("num_games") and params["num_games"] != "") ? params["num_games"].to_i : 82
    #filters[:exclude_players] = ignorable

    # @stats = if (params.has_key?('lookup_type') && params['lookup_type'] == 'Average')
    puts 'this is updating'
    @stats = CumulativeGame.get_normalized_average_stats(categories, num_games, min_games, filters)
    # else
    #   CumulativeGame.get_normalized_stats(@categories, @weights, num_games, min_games, filters)
    # end
    puts @stats.first

  end

  private

  def build_filters
    filters = {}

    filters[:age_between] = params['ageRange'] if params['ageRange']
    filters[:years_in_league_between] = params['yearsInLeague'] if params['yearsInLeague']

    filters
  end

  def default_categories
    [
      {name: 'goals', weight: 1},
      {name: 'assists', weight: 1},
      {name: 'shots', weight: 1},
      {name: 'blocks', weight: 1},
      {name: 'hits', weight: 1},
      {name: 'pim', weight: 1},
      {name: 'ppp', weight: 1},
      {name: 'gwg', weight: 1},
      {name: 'plus_minus', weight: 1}
    ]
  end
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

