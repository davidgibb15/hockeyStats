class Api::V1::PlayersController < ApplicationController
	def index
		render json: Player.select("name", "id").order('name ASC')
	end
end