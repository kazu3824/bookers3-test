Rails.application.routes.draw do
  get 'chats/show'
  root to: "homes#top"
  get "home/about"=>"homes#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
   resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update]do
    resources :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
    get 'search' => 'searches#search', as: 'search'
    get 'chat/:id', to: 'chats#show', as: 'chat'
    resources :chats, only: [:create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 end

