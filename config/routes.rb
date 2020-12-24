Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users
  resources :users
  resources :books
  post 'users/:id' => 'books#show'
  get '/home/about', to: 'homes#about'
end
