Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "zaklad/nowy"
  get "gracze/nowy"
  get "public/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'public#home'
  get 'roulette', to: 'games#roulette'
  get 'blackjack', to: 'games#blackjack', as: :blackjack
  post 'blackjack/deal', to: 'games#blackjack_deal', as: :blackjack_deal
  post 'blackjack/hit', to: 'games#blackjack_hit', as: :blackjack_hit
  post 'blackjack/stand', to: 'games#blackjack_stand', as: :blackjack_stand
  match 'slots', to: 'games#slots', via: [:get, :post]
  get 'account', to: 'users#account'
  get "gracze/nowy", to: "gracze#nowy"
  get "zaklad/nowy", to: "zaklad#nowy"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  get  "roulette",        to: "games#roulette"
  post "roulette/spin",   to: "games#spin_roulette", as: :spin_roulette
end
