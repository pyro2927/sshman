Sshman::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks"}
  resources :users
  resources :keys, only: [:destroy]
  get '/sync_keys', to: 'users#merge_and_sync'
  authenticated :user do
    root :to => "users#show"
  end
  unauthenticated :user do
    root :to => "home#index", :as => :unauthenticated_root
  end
end
