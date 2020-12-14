Rails.application.routes.draw do
  
  root to: "tweets#index"

  resources :tweets
  
  put 'tweet/:id/like', to: 'tweets#like', as: 'like'
  delete 'tweet/:id/dislike', to: 'tweets#dislike', as: 'dislike'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
