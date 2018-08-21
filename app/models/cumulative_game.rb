class CumulativeGame < ApplicationRecord
  MAXES = {"goals": 0.6, "assists": 0.89, "points": 1.32, "hits": 4.3, "blocks": 2.9, "shots": 4.29, "pim": 2.9, "ppg": 0.25, "ppa": 0.43, "ppp": 0.5, "shg": 0.0667, "sha": 0.0714, "shp": 0.0877, "gwg": 0.15, "otg": 0.0769, "plus_minus": 0.613, "toi": 1680, "mss": 1.95, "gva": 1.59, "tka": 1.34, "fow": 15.679, "fot": 26.1, "fol": 11.013}.with_indifferent_access
  MINS = {"goals": 0, "assists": 0.0175, "points": 0.0256, "hits": 0.01, "blocks": 0, "shots": 0.43, "pim": 0.017, "ppg": 0, "ppa": 0, "ppp": 0, "shg": 0, "sha": 0, "shp": 0, "gwg": 0, "otg": 0, "plus_minus": -0.532, "toi": 422, "mss": 0.146, "gva": 0.036, "tka": 0.042, "fow": 0, "fot": 0, "fol": 0}.with_indifferent_access

  belongs_to :player

  validates_presence_of :date, :player, :goals, :assists, :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :sha, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp
  validates_numericality_of :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp
  validates_numericality_of :goals, greater_than_or_equal_to: Proc.new {|c_game| c_game.ppg + c_game.shg }
  validates_numericality_of :assists, greater_than_or_equal_to: Proc.new {|c_game| c_game.ppa + c_game.sha }
  validate :stats_go_up


  def stats_go_up
  	if(gp.present? and gp > 1)
  		last_game = CumulativeGame.where(player: player, gp: gp - 1).limit(1)[0]
  		if(last_game.date > date)
  			errors.add(:date, "date cannot be less than previous game")
  		end

  		if(last_game.goals > goals)
  			errors.add(:goal, "goals cannot be less than previous game")
  		end

  		if(last_game.assists > assists)
  			errors.add(:assists, "assists cannot be less than previous game")
  		end

  		if(last_game.hits > hits)
  			errors.add(:hits, "hits cannot be less than previous game")
  		end

  		if(last_game.blocks > blocks)
  			errors.add(:blocks, "blocks cannot be less than previous game")
  		end

  		if(last_game.shots > shots)
  			errors.add(:shots, "shots cannot be less than previous game")
  		end

  		if(last_game.pim > pim)
  			errors.add(:pim, "pim cannot be less than previous game")
  		end

  		if(last_game.ppg > ppg)
  			errors.add(:ppg, "ppg cannot be less than previous game")
  		end

  		if(last_game.ppa > ppa)
  			errors.add(:ppa, "ppa cannot be less than previous game")
  		end

   		if(last_game.shg > shg)
  			errors.add(:shg, "shg cannot be less than previous game")
  		end

  		if(last_game.sha > sha)
  			errors.add(:sha, "sha cannot be less than previous game")
  		end

  		if(last_game.gwg > gwg)
  			errors.add(:gwg, "gwg cannot be less than previous game")
  		end

  		if(last_game.otg > otg)
  			errors.add(:otg, "otg cannot be less than previous game")
  		end

  		if(last_game.toi > toi)
  			errors.add(:toi, "toi cannot be less than previous game")
  		end

  		if(last_game.mss > mss)
  			errors.add(:gva, "gva cannot be less than previous game")
  		end

  		if(last_game.tka > tka)
  			errors.add(:tka, "tka cannot be less than previous game")
  		end

  		if(last_game.tka > tka)
  			errors.add(:tka, "tka cannot be less than previous game")
  		end

  		if(last_game.fow > fow)
  			errors.add(:fow, "ppa cannot be less than previous game")
  		end

  		if(last_game.fot > fot)
  			errors.add(:fow, "ppa cannot be less than previous game")
  		end
  	end
  end

  def self.execute_sql(*sql_array)     
    ActiveRecord::Base.connection.execute(send(:sanitize_sql_array, sql_array))
  end

  def self.calculate_age_date(age)
    Date.today.years_ago(age)
  end

  def self.get_games(categories, num_games, filters)
    categories= categories.join(", ")
    categories << ", player_id, name, gp"

    query_string = 
      "SELECT #{categories} FROM 
      (SELECT ROW_NUMBER() 
        OVER (PARTITION BY player_id 
          ORDER BY gp DESC) as r, 
          cumulative_games.*, name, birth_date 
          FROM cumulative_games 
          LEFT JOIN players ON players.id = cumulative_games.player_id"
    args = [] 

    unless filters.empty?
      query_string = query_string + " WHERE"
      where_started = false

      if filters.key?(:age)
        query_string = query_string + "( players.birth_date <= ? AND players.birth_date >= ?)"
        where_started = true
        args << calculate_age_date(filters[:age][0])
        args << calculate_age_date(filters[:age][1]+1)
      end

      if filters.key?(:include_players)
        if where_started
          query_string = query_string + " AND"
        end
        query_string = query_string + " ("
        filters[:include_players].each_with_index do |player_id, i|
          unless i == 0
            query_string = query_string + " OR "
          end
          query_string = query_string + "cumulative_games.player_id = ?"
          args << player_id
        end
        query_string = query_string + ")"
        where_started = true
      elsif filters.key?(:exclude_players)
        if where_started
          query_string = query_string + " AND"
        end
        query_string = query_string + " ("
        filters[:exclude_players].each_with_index do |player_id, i|
          unless i == 0
            query_string = query_string + " OR "
          end
          query_string = query_string + "cumulative_games.player_id != ?"
          args << player_id
        end
        query_string = query_string + ")"
        where_started = true
      end

      #if filters.key?("include_teams")
        #query_string = query_string + ""
      #end

      if filters.key?(:positions)
        if where_started
          query_string = query_string + " AND"
        end
        query_string = query_string + " ("
        filters[:positions].each_with_index do |position, i|
          unless i == 0
            query_string = query_string + " OR "
          end
          query_string = query_string + "players.position = ?"
          args << position
        end
        query_string = query_string + ")"
        where_started = true
      end

      if filters.key?(:years_in_league)
        if where_started
          query_string = query_string + " AND"
        end
        query_string = query_string + "( players.years_in_league >= ? AND players.years_in_league <= ?)"
        args << filters[:years_in_league][0]
        args << filters[:years_in_league][1]
        where_started = true
      end
    end
    query_string = query_string + ") x 
      WHERE x.r =#{num_games+1} 
      or x.r=1 
      ORDER BY player_id"
    execute_sql(query_string, *args)
  end

  def self.get_games_old(categories, num_games, filters = {})
  	categories= categories.join(", ")
    categories << ", player_id, name, gp"
    #the inner select selects all the stats and name from all players most recent and nth most recent game
    result=execute_sql(
      "SELECT #{categories} FROM 
        (SELECT 
          ROW_NUMBER() OVER 
          (PARTITION BY player_id 
            ORDER BY gp DESC
          ) as r, 
          cumulative_games.*, name 
          FROM cumulative_games 
          LEFT JOIN players ON players.id = cumulative_games.player_id
        ) x 
      WHERE x.r =#{num_games+1} 
      or x.r=1 
      ORDER BY player_id")
  end 

  def self.get_raw_range_totals(categories, num_games, filters)
  	all_games = get_games(categories, num_games, filters).to_a
  	all_games.to_a.sort_by!{|game| [game["player_id"], game["gp"]]}
  	all_players_stats_in_range = []
  	previous_game = {"player_id": -1}
  	all_games.each_with_index do |game, i|
  		if game["player_id"] == previous_game[:player_id]
  			all_players_stats_in_range << calculate_range_stats(previous_game, game, categories)
  		elsif i == all_games.length - 1 || game["player_id"] != all_games[i+1]["player_id"]
  			all_players_stats_in_range << game
  		end
  		previous_game = game
  	end
  	all_players_stats_in_range
  end

  def self.get_normalized_stats(categories, weights, num_games, min_games)
    raw_stats = get_raw_range_totals(categories, num_games)
    
    normalized_stats = normalize_stats(raw_stats, categories, weights, num_games)
    add_total_score(normalized_stats, categories)
    normalized_stats.sort_by!{ |stat_line| -stat_line["score"] }
  end

  def self.get_normalized_average_stats(categories, weights, num_games, min_games, filters)
    raw_stats = get_raw_range_totals(categories, num_games, filters)
    filter_out_low_games_player(raw_stats, min_games)
    average_stats(raw_stats, categories)
    normalized_stats = normalize_stats(raw_stats, categories, weights)
    add_total_score(normalized_stats, categories)
    normalized_stats.sort_by!{ |stat_line| -stat_line["score"] }

  end

  private

  def self.filter_out_low_games_player(stats, min_games)
    stats.reject!{ |k| k["gp"] < min_games}
  end

  def self.calculate_range_stats(cumulative_total_beginning, cumulative_total_end, queried_categories)
  	valid_calculatable_categories = ["goals", "assists", "points", "hits", "blocks", "shots", "pim", "ppg", "ppa","ppp", "shg", "sha","shp", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot", "fol", "plus_minus" "gp"]
  	calculatable_categories = queried_categories & valid_calculatable_categories
  	calculatable_categories.each do |category|
  		cumulative_total_end[category] = cumulative_total_end[category] - cumulative_total_beginning[category]
  	end
  	cumulative_total_end
  end

  def self.average_stats(raw_stats, queried_categories)
    valid_averagable_categories = ["goals", "assists", "points", "hits", "blocks", "shots", "pim", "ppg", "ppa","ppp", "shg", "sha","shp", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot", "fol", "plus_minus"]
    present_averagable_categories = queried_categories & valid_averagable_categories
    raw_stats.each do |stat_line|
      gp = stat_line["gp"]
      present_averagable_categories.each do |category|
        stat_line[category] = stat_line[category].to_f/gp
      end
    end
  end

  def self.normalize_stats(raw_stats, queried_categories, weights, num_games = 1)
    valid_normalizable_categories = ["goals", "assists", "points", "hits", "blocks", "shots", "pim", "ppg", "ppa","ppp", "shg", "sha","shp", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot", "fol", "plus_minus"]
    present_normalizable_categories = valid_normalizable_categories & queried_categories
    raw_stats.each do |stat_line|
      present_normalizable_categories.each do |category|
        stat_line[category] = (stat_line[category].to_f - MINS[category]*num_games)/((MAXES[category]-MINS[category])*num_games)
        stat_line[category] = stat_line[category] * weights[category]
      end
    end
  end

  def self.add_total_score(stats, queried_categories)
    valid_scorable_categories = ["goals", "assists", "points", "hits", "blocks", "shots", "pim", "ppg", "ppa","ppp", "shg", "sha","shp", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot", "fol", "plus_minus"]
    present_scorable_categories = queried_categories & valid_scorable_categories
    stats.each do |stat_line|
      score = 0
      present_scorable_categories.each do |category|
        score = score + stat_line[category]
      end
      stat_line["score"] = score
    end
  end

end
