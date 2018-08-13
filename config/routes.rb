Rails.application.routes.draw do
  get 'cumulative_games/index'
	get 'players/index'

	root 'cumulative_games#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
