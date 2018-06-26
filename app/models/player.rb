class Player < ApplicationRecord
  belongs_to :team
  has_many :cumulative_games
end
