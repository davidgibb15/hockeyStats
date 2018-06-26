require 'rails_helper'

RSpec.describe CumulativeGame, type: :model do

	it "is valid with valid attributes" do
		expect(create(:cumulative_game)).to be_valid
	end

	it "is not valid with more ppg and shg then goals" do
		c_game = create(:cumulative_game)
		c_game.ppg = 2
		expect(c_game).to_not be_valid
	end

	it "is not valid with more ppa and sha then assists" do
		c_game = create(:cumulative_game)
		c_game.sha = 2
		expect(c_game).to_not be_valid
	end
end