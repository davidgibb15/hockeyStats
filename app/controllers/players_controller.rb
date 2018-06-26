class PlayersController < ApplicationController
	def index
		@players = Player.all
		puts @players
		puts '-------------------'
	end
end