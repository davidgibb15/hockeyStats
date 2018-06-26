class CumulativeGame < ApplicationRecord
  belongs_to :player
  belongs_to :team
  belongs_to :opponent_team, class_name: "Team"

  validates_presence_of :date, :home, :player, :team, :opponent_team, :goals, :assists, :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :sha, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp
  validates_numericality_of :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp
  validates_numericality_of :goals, greater_than_or_equal_to: Proc.new {|c_game| c_game.ppg + c_game.shg }
  validates_numericality_of :assists, greater_than_or_equal_to: Proc.new {|c_game| c_game.ppa + c_game.sha }
  validates_inclusion_of :home, in: [true, false]
  validate :check_team_and_opponent
  validate :stats_go_up

  def check_team_and_opponent
  	if(team == opponent_team)
  		errors.add(:team, "team cannot play itself")
  	end
  end

  def stats_go_up
  	#get last game stats for player
  	#make sure they go up
  end
end
