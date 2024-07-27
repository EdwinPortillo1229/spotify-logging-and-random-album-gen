Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "application#landing_page"

  get "/spotify" => "spotify#spotify"
  get "/link_spotify" => "spotify#link_spotify"
  get "/linked_spotify" => "spotify#linked_spotify"
  get "/random_albums/:spotify_user_id" => "spotify#random_albums"
  get "/get_random_albums/:spotify_user_id" => "spotify#get_random_albums"
  get "/load_albums_page/:spotify_user_id" => "spotify#load_albums_page"
  post "/load_albums" => "spotify#load_albums"
end
