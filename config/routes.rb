Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/users', to: 'users#create'
  resources :posts do
    resources :comments, except: [:update]
  end
end
