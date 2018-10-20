Rails.application.routes.draw do
  	get 'cumulative_games/search', as: "stats"
	get 'players/index'
	get 'api/v1/players/index'
	get 'api/v1/search/search'
	root 'cumulative_games#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
