Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # namespace :apis, defaults: {format: 'json'} do 
  #   # mount_devise_token_auth_for :users, at: 'auth', skip: [:omniauth_callbacks]
  #   resources :api, only [] do
  #     collection do
  #       get 'api/news'
  #       get 'api/:date1/:date2', to: 'api#by_date'
  #       post 'api/create', to: 'api#create'
  #     end
  #   end
  # end
  

  get 'api/news'
  get 'api/:date1/:date2', to: 'api#by_date'
  post 'api/create', to: 'api#create'

        
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root to: "tweets#index"

  resources :tweets
  
  put 'tweet/:id/like', to: 'tweets#like', as: 'like'
  delete 'tweet/:id/dislike', to: 'tweets#dislike', as: 'dislike'

  post 'tweet/:id/retweet', to: 'tweets#retweet', as: 'retweet'

  get 'tweets/search/:search', to: 'tweets#search', as: 'search'


  get 'home/profile', to: 'home#profile'
  get 'home/tweets', to: 'home#tweets'
  post 'home/:id/follow', to: "home#follow", as: "follow_user"
  delete 'home/:id/unfollow', to: "home#unfollow", as: "unfollow_user"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
