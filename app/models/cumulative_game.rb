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
  	if(gp.present? and gp > 1)
  		last_game = CumulativeGame.where(player: player, gp: gp - 1).limit(1)[0]
  		if(last_game.date >= date)
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

   		if(last_game.shg >= shg)
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
end
