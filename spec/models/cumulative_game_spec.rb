require 'rails_helper'

def player_with_games (name, num_games)
	increasing_attributes = ["date", "goals", "assists", "hits", "blocks", "shots", "pim", "ppg", "ppa", "shg", "sha", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot"]
	player = create(:player, name: name)

	previous_game = create(:cumulative_game, player: player)
	(num_games-1).times do 
		new_game = build(:cumulative_game, player: player)
		increasing_attributes.each do |attribute|
			new_game.send("#{attribute}=", previous_game.send("#{attribute}") + 1)
			new_game.gp = previous_game.gp + 1
		end
		new_game.goals = new_game.goals + 1
		new_game.assists = new_game.assists + 1
		new_game.save
		
		previous_game = new_game
	end
	player
end

RSpec.describe CumulativeGame, type: :model do

	present_attributes = [:player, :date, :goals, :assists, :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :sha, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp]
	present_attributes.each do |attribute|
		it { should validate_presence_of(attribute) }
	end

	it { should belong_to :player }

	it "is valid with valid attributes" do
		expect(create(:cumulative_game)).to be_valid
	end

	it "is not valid with more ppg and shg then goals" do
		c_game = build(:cumulative_game, ppg: 2)
		expect(c_game).to_not be_valid
	end

	it "is not valid with more ppa and sha then assists" do
		c_game = build(:cumulative_game, sha: 2)
		expect(c_game).to_not be_valid
	end

	increasing_attributes = ["date", "goals", "assists", "hits", "blocks", "shots", "pim", "ppg", "ppa", "shg", "sha", "gwg", "otg", "toi", "mss","gva", "tka", "fow", "fot"]
	increasing_attributes.each do |attribute|
		it "a players game has a #{attribute} greater or equal to than his previous game" do
			game1 = create(:cumulative_game)
			game1.send("#{attribute}=", game1.send("#{attribute}")+1)
			game1.save
			game2 = build(:cumulative_game, gp: 2, player: game1.player)
			game2.date = game1.date - 1
			expect(game2).to_not be_valid
		end
	end

	it "can get every players most recent game" do
		player1 = player_with_games("player1", 10)
		player2 = player_with_games("player2", 20)
		player3 = player_with_games("player3", 1)
		all_games = described_class.get_games(["*"], 10)
		
		expect(all_games.any?{|h| h["gp"] == 10 and  h["player_id"] == player1.id }).to be true
		expect(all_games.any?{|h| h["gp"] == 20 and  h["player_id"] == player2.id }).to be true
		expect(all_games.any?{|h| h["gp"] == 1 and  h["player_id"] == player3.id }).to be true
	end

	it "can get every placers nth game ago" do
		player1 = player_with_games("player1", 10)
		player2 = player_with_games("player2", 20)
		player3 = player_with_games("player3", 1)
		all_games = described_class.get_games(["*"], 9)

		expect(all_games.any?{|h| h["gp"] == 1 and  h["player_id"] == player1.id }).to be true
		expect(all_games.any?{|h| h["gp"] == 11 and  h["player_id"] == player2.id }).to be true
		expect(all_games.any?{|h| h["gp"] == 2 and  h["player_id"] == player3.id }).to be false
		
	end

	# this requires the two above specs to be passing
	it "can grab the right number of games" do
		player2 = player_with_games("player2", 20)
		player1 = player_with_games("player1", 11)
		player4 = player_with_games("player4", 10)
		player3 = player_with_games("player3", 4)
		
		all_games = described_class.get_games(["*"], 10)
		expect(all_games.count).to eq(6)
	end

	it "can get the correct range totals" do
		player1 = player_with_games("player1", 10)
		player2 = player_with_games("player2", 20)
		player3 = player_with_games("player3", 1)
		player4 = player_with_games("player4", 5)
		
		range_totals = described_class.get_raw_range_totals(["goals", "player_id", "gp"], 10)

		expect(range_totals.any?{|h| h["player_id"] == player1.id and h["goals"] == 18}).to be true
		expect(range_totals.any?{|h| h["player_id"] == player2.id and h["goals"] == 20}).to be true
		expect(range_totals.any?{|h| h["player_id"] == player3.id and h["goals"] == 0}).to be true
		expect(range_totals.any?{|h| h["player_id"] == player4.id and h["goals"] == 8}).to be true
	end

	it "can calculate range stats" do
		player1 = player_with_games("player1", 10)
		categories = ["goals", "player_id", "gp", "assists", "name"]
		games_1_10 = described_class.get_games(categories,9).to_a
		games_3_10 = described_class.get_games(categories,7).to_a
		cgame = CumulativeGame.new
		range_stats_1_10 = described_class.send(:calculate_range_stats, games_1_10[1], games_1_10[0], categories)
		range_stats_3_10 = described_class.send(:calculate_range_stats, games_3_10[1], games_3_10[0], categories)
		expect range_stats_1_10["goals"] == 18
		expect range_stats_3_10["goals"] == 14
		expect range_stats_3_10["gp"] == 7
		expect range_stats_1_10["gp"] == 9
	end

	it "can calculate averages" do
		player1 = player_with_games("player1", 10)
		player2 = player_with_games("player2", 2)
		player3 = player_with_games("player3", 3)

		stats = described_class.get_raw_range_totals(["goals", "player_id", "gp", "assists", "name"], 9)
		described_class.average(stats, ["goals", "assists", "gp"])
		expect(stats.any?{|s| s["name"] == "player1" and s["goals"] ==2.0}).to be true
		expect(stats.any?{|s| s["name"] == "player2" and s["assists"] ==1.0}).to be true
		expect(stats.any?{|s| s["name"] == "player3" and s["goals"] ==4.0/3}).to be true
	end

end