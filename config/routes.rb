Rails.application.routes.draw do
  namespace :public do
    get 'homes/top'
  end
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admins, skip: [:registrations, :passwords] , controllers: {
  sessions: "admin/sessions"
  }
  
  
  namespace :admin do
    devise_scope :admin do
      get '/sign_in' => 'sessions#new'
      post '/sign_in' => 'sessions#create'
      delete '/sign_out' => 'sessions#destroy'
    end  
    get '' => 'homes#top'
    resources :items
    resources :genres, only: [:create, :index, :edit, :update]
    resources :customers
    resources :orders
    resources :order_details
  end
  
  
  
  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }
  root to: 'public/homes#top'
  get 'homes/about' => 'homes#about', as: '/about'
  get '/customers/my_page' => 'customers#show'
  
  namespace :public do
    resources :items
    resources :customers
    resources :cart_items
    resources :orders
    resources :addresses
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
