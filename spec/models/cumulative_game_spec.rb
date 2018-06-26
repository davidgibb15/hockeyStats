require 'rails_helper'

RSpec.describe CumulativeGame, type: :model do

	present_attributes = [:player, :date, :home, :team, :opponent_team, :goals, :assists, :hits, :blocks, :shots, :pim, :ppg, :ppa, :shg, :sha, :gwg, :otg, :plus_minus, :toi, :mss, :gva, :tka, :fow, :fot, :gp]
	present_attributes.each do |attribute|
		it { should validate_presence_of(attribute) }
	end

	it { should belong_to :team }
	it { should belong_to :player }

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