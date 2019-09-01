require 'net/http'
require 'json'
require 'set'
require 'pry'
require 'active_record'
require_relative "../config/environment.rb"
def get_i_games
	url = "http://www.nhl.com/stats/rest/skaters?isAggregate=false&reportType=basic&isGame=true&reportName=skatersummary&cayenneExp=gameDate>=\"2018-09-09\" and gameDate<=\"2019-10-28\" and gameTypeId=2"
	uri = URI(url)

	response = Net::HTTP.get(uri)
	games = []
	puts JSON.parse(response)['data'].count
	JSON.parse(response)['data'].each do |stat_line|
		game = {}
		game[:nhl_id] = stat_line["gameId"]
		game[:assists] = stat_line["assists"]
		game[:date] = stat_line["gameDate"]
		game[:gwg] = stat_line["gameWinningGoals"]
		game[:goals] = stat_line["goals"]
		game[:otg] = stat_line["otGoals"]
		game[:pim] = stat_line["penaltyMinutes"]
		game[:nhl_player_id] = stat_line["playerId"] 
		game[:plus_minus] = stat_line["plusMinus"]
		game[:points] = stat_line["points"]
		game[:ppg] = stat_line["ppGoals"] 
		game[:ppp] = stat_line["ppPoints"]
		game[:ppa] = game[:ppp] - game[:ppg]
		game[:shg] = stat_line["shGoals"]
		game[:shp] = stat_line["shPoints"]
		game[:sha] = game[:shp] - game[:shg]
		game[:shots] = stat_line["shots"]
		game[:toi] = stat_line["timeOnIcePerGame"] 

		games <<  game
	end

	url = "http://www.nhl.com/stats/rest/skaters?isAggregate=false&reportType=basic&isGame=true&reportName=realtime&cayenneExp=gameDate>=\"2018-09-09\" and gameDate<=\"2019-10-28\" and gameTypeId=2"
	uri = URI(url)
	response = Net::HTTP.get(uri)
	full_games=[]
	puts JSON.parse(response)['data'].count
	JSON.parse(response)['data'].each do |stat_line|
		game = {}
		id = stat_line["gameId"]
		playerId = stat_line["playerId"]
		game[:blocks] = stat_line["blockedShots"]
		game[:fot] = stat_line["faceoffs"]
		game[:fow] = stat_line["faceoffsWon"]
		game[:fol] = stat_line["faceoffsLost"]
		game[:gva] = stat_line["giveaways"]
		game[:hits] = stat_line["hits"]
		game[:mss] = stat_line["missedShots"]
		game[:tka] = stat_line["takeaways"]
		matching_game = games.select {|g| g[:nhl_player_id] == playerId && g[:nhl_id] == id }
		if matching_game.length > 1
			raise 'Too many matching games'
		end
		full_games << matching_game[0].merge(game)
	end
	#http://www.nhl.com/stats/rest/skaters?isAggregate=false&reportType=core&isGame=true&reportName=skaterscoring&cayenneExp=gameDate>="2017-10-04" and gameDate<="2018-04-09" and gameTypeId=2

	File.open("igames1617.json","w") do |f|
  		f.write(full_games.to_json)
	end

end

def get_players
	file = File.read('igames1617.json')
	igames = JSON.parse(file)
	nhl_player_ids = Set[]
	igames.each do |igame|
		if !Player.find_by(nhl_id: igame["nhl_id"]).present?
			nhl_player_ids << igame["nhl_player_id"]
		end
	end
	puts nhl_player_ids.count
	players = []
	nhl_player_ids.each do |id|
		sleep 0.1
		player = {}
		url = "https://statsapi.web.nhl.com/api/v1/people/#{id}?expand=person.stats&stats=yearByYear,careerRegularSeason"
		uri = URI(url)
		response = Net::HTTP.get(uri)
		data = JSON.parse(response)['people'][0]
		player[:nhl_id] = id
		if player[:nhl_id].nil?
			puts "#{id} has nil id"
		end
		player[:name] = data['fullName']
		if player[:name].nil?
			puts "#{id} has nil name"
		end
		player[:team] = data['currentTeam'].nil? ? nil : data['currentTeam']['name']

		player[:birth_date] = data['birthDate']
		if player[:birth_date].nil?
			puts "#{id} has nil birthDate"
		end
		count = 0
		seasons = data['stats'][0]['splits']
		seasons.each do |season|
			if season['league']['id'] == 133
				count = count + 1
			end 
		end
		player[:years_in_league] = count
		if player[:years_in_league] == 0
			puts "#{id} has 0 years in league"
		end
		player[:position] = data['primaryPosition']['abbreviation']
		players << player
	end

	File.open("players1617.json","w") do |f|
  		f.write(players.to_json)
	end
end

def create_teams
	puts "creating_teams"
	file = File.read("players.json")
	players = JSON.parse(file)
	teams = Set[]
	players.each do |player|
		teams << player["team"]
	end
	teams.each do |team|
		Team.create(name: team)
	end
end

def create_players
	puts "creating players"
	file = File.read("players.json")
	players = JSON.parse(file)
	players.each do |player|
		
		team = Team.find_by(name: player["team"])
		Player.create(
			name: player["name"],
			nhl_id: player["nhl_id"],
			birth_date: player["birth_date"],
			years_in_league: player["years_in_league"],
			team: team,
			position: player["position"])
	end
end

def create_c_games
	puts "creating c_games"
	file = File.read("igames.json")
	player_gp = {}
	Player.all.each do |player|
		player_gp[player["nhl_id"]] = 0
	end
	igames = JSON.parse(file)
	igames.sort_by! {|hash| [hash["nhl_player_id"], hash["date"]]}
	i = 0
	igames.each do |stat_line|
		puts i
		i=i+1
		if player_gp[stat_line["nhl_player_id"].to_s] > 0
			player = Player.find_by(nhl_id: stat_line["nhl_player_id"])
			prev_stats = player.cumulative_games.find_by(gp: player_gp[stat_line["nhl_player_id"].to_s])
			stat_line["goals"] = prev_stats["goals"] + stat_line["goals"]
			stat_line["assists"] = prev_stats["assists"] + stat_line["assists"]
			stat_line["hits"] = prev_stats["hits"] + stat_line["hits"]
			stat_line["blocks"] = prev_stats["blocks"] + stat_line["blocks"]
			stat_line["shots"] = prev_stats["shots"] + stat_line["shots"]
			stat_line["pim"] = prev_stats["pim"] + stat_line["pim"]
			stat_line["ppg"] = prev_stats["ppg"] + stat_line["ppg"]
			stat_line["ppp"] = prev_stats["ppp"] + stat_line["ppp"]
			stat_line["ppa"] = prev_stats["ppa"] + stat_line["ppa"]
			stat_line["points"] = prev_stats["points"] + stat_line["points"]
			stat_line["shg"] = prev_stats["shg"] + stat_line["shg"]
			stat_line["sha"] = prev_stats["sha"] + stat_line["sha"]
			stat_line["shp"] = prev_stats["shp"] + stat_line["shp"]
			stat_line["gwg"] = prev_stats["gwg"] + stat_line["gwg"]
			stat_line["otg"] = prev_stats["otg"] + stat_line["otg"]
			stat_line["plus_minus"] = prev_stats["plus_minus"] + stat_line["plus_minus"]
			stat_line["toi"] = prev_stats["toi"] + stat_line["toi"]
			stat_line["mss"] = prev_stats["mss"] + stat_line["mss"]
			stat_line["gva"] = prev_stats["gva"] + stat_line["gva"]
			stat_line["tka"] = prev_stats["tka"] + stat_line["tka"]
			stat_line["fow"] = prev_stats["fow"] + stat_line["fow"]
			stat_line["fot"] = prev_stats["fot"] + stat_line["fot"]
			stat_line["fol"] = prev_stats["fol"] + stat_line["fol"]
		end
		gp = player_gp[stat_line["nhl_player_id"].to_s] +1
		player_gp[stat_line["nhl_player_id"].to_s]=player_gp[stat_line["nhl_player_id"].to_s] +1

		c = CumulativeGame.create(player: Player.find_by(nhl_id: stat_line["nhl_player_id"]), nhl_id: stat_line["nhl_id"], date: stat_line["date"], goals: stat_line["goals"], assists: stat_line["assists"], hits: stat_line["hits"], blocks: stat_line["blocks"], shots: stat_line["shots"], pim: stat_line["pim"], ppg: stat_line["ppg"], ppp: stat_line["ppp"], ppa: stat_line["ppa"], points: stat_line["points"], shg: stat_line["shg"], sha: stat_line["sha"], shp: stat_line["shp"], gwg: stat_line["gwg"], otg: stat_line["otg"], plus_minus: stat_line["plus_minus"], toi: stat_line["toi"], mss: stat_line["mss"], gva: stat_line["gva"], tka: stat_line["tka"], fow: stat_line["fow"], fot: stat_line["fot"], fol: stat_line["fol"], gp: gp)
	end
end
create_c_games