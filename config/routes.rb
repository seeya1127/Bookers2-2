Rails.application.routes.draw do
  # get 'favorites/create'
  # get 'favorites/destroy'
  root to: 'homes#top'
  get '/home/about', to: 'homes#about'
  devise_for :users
  
  resources :users
  resources :books do
    resource :favorites, only: [:create, :destroy] 
    resources :books_comments, only: [:create, :destroy]
  end
end
