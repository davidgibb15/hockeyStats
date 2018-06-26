# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
case Rails.env
when "development"
	team = Team.create({name: "Bulkey Valley Rapids", division: "NWBC"})
	team2 = Team.create({name: "Prince George Cougars", division: "NWBC"})
	player = Player.create({name: "Charlie Barktowski", team_id: team.id, lw: true, rw: true, c: true, d: true, g: true, age: 9})
	CumulativeGame.create(player_id: player.id) do |cGame|
      cGame.date = Date.new(2001,2,3)
      cGame.home = true
      cGame.team_id = team.id
      cGame.opponent_team_id = team2.id
      cGame.goals = 1
      cGame.assists = 1
      cGame.hits = 2
      cGame.blocks = 4
      cGame.shots = 5
      cGame.pim = 0
      cGame.ppg = 0
      cGame.ppa = 1
      cGame.shg = 1
      cGame.sha = 0
      cGame.gwg = 1
      cGame.otg = 1
      cGame.plus_minus = 2
      cGame.toi = 1200
      cGame.mss = 2
      cGame.gva = 1
      cGame.tka = 3
      cGame.fow = 1
      cGame.fot = 2
	end
when "production"
end