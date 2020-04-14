Rails.application.routes.draw do

	get 'users/:id/posts/' => 'users#posts_index'

	resources :posts

	resources :users do
		collection do
			post 'login'
		end
	end
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
