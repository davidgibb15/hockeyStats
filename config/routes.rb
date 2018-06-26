Rails.application.routes.draw do
	get 'players/index'

	root 'players#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
