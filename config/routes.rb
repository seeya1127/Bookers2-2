Rails.application.routes.draw do
  # get 'favorites/create'
  # get 'favorites/destroy'
  root to: 'homes#top'
  get '/home/about', to: 'homes#about'
  devise_for :users

  resources :users do
    resource :relationships, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
  end

  resources :books do
    resource :favorites, only: [:create, :destroy]#ブックIDの取得を簡単にする,favのidはいらないのでresource
    resources :books_comments, only: [:create, :destroy]#ブックIdを取得
  end

  get 'search' => 'searches#search'
end
