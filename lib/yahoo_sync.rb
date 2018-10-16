require 'oauth'
require 'active_support/core_ext/hash'
require 'json'
require 'active_record'
require_relative "../config/environment.rb"

CONSUMER_KEY = 'dj0yJmk9aE8yZkhIdzJmTGpEJmQ9WVdrOWFIbEVWMFJqTTJVbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1hZQ--'
CONSUMER_SECRET = 'cfbb2945ec7fb80b07aa4d1813adca7545101627'
 def get_players 
  end_point = 'http://fantasysports.yahooapis.com'

  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {site: end_point, scheme: :header})
  i = 0
  resp = consumer.request(:get, "/fantasy/v2/game/nhl/players;start=#{i}", nil, {}, 'output=json', {})
  players = []
  while resp.body.include? "<player>"
    hashed_response = Hash.from_xml(resp.body)
    hashed_response["fantasy_content"]["game"]["players"]["player"].each do |player|
      new_player = {}
      new_player["name"] = player["name"]["full"]
      new_player["yahoo_id"] = player["player_id"]
      new_player["yahoo_positions"] = player["eligible_positions"]
      # player["team_name"] = player["editorial_team_full_name"]
      players << new_player
    end

    i = i + 25
  puts i
    resp = consumer.request(:get, "/fantasy/v2/game/nhl/players;start=#{i}", nil, {}, 'output=json', {})
  end

  File.open("yahoo_players.json","w") do |f|
    f.write(players.to_json)
  end
end

def update_players
  file = File.read("lib/yahoo_players.json")
  players = JSON.parse(file)
  players.each do |player|
    existing_players = Player.where(name: player["name"])
    if existing_players.count > 1
      puts "TOO MANY PLAYERS with name #{player['name']}"
    elsif existing_players.count == 0
      puts "couldnt find a player with name #{player['name']}"
    else
      positions = player["yahoo_positions"]["position"]
      existing_players.first.update_attributes(yahoo_id: player["yahoo_id"],yahoo_lw: false, yahoo_rw: false, yahoo_c: false, yahoo_d: false, yahoo_g: false)
      if positions.include? "LW"
        existing_players.first.update_attribute(:yahoo_lw, true)
      end
      if positions.include? "RW"
        existing_players.first.update_attribute(:yahoo_rw, true)
      end
      if positions.include? "C"
        existing_players.first.update_attribute(:yahoo_c, true)
      end
      if positions.include? "D"
        existing_players.first.update_attribute(:yahoo_d, true)
      end
    end
      
  end
end
update_players