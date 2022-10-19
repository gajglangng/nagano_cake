Rails.application.routes.draw do
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
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
  devise_for :customers, skip: [:passwords], controllers: {
   registrations: "public/registrations",
   sessions: 'public/sessions'
  }
  root to: 'homes#top'
  get 'homes/about' => 'homes#about', as: 'about'
  
  scope module: :public do
    
    resources :customers, only: [:edit, :update]
    get '/customers/my_page' => 'customers#show'
    get '/customers/unsubscribe' => 'customers#unsubscribe'
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:create, :destroy, :update]
    resources :orders, only: [:new, :create, :show, :index]
    post '/orders/confirm' => 'orders#confirm'
    get '/orders/complete' => 'orders#order_complete'
    resources :addresses, only: [:index, :create, :destroy, :edit, :update]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
