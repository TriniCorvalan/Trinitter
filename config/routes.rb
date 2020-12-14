Rails.application.routes.draw do
  
  root to: "tweets#index"

  resources :tweets
  
  put 'tweet/:id/like', to: 'tweets#like', as: 'like'
  delete 'tweet/:id/dislike', to: 'tweets#dislike', as: 'dislike'

  post 'tweet/:id/retweet', to: 'tweets#retweet', as: 'retweet'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'home/profile', to: 'home#profile'
  get 'home/tweets', to: 'home#tweets'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
