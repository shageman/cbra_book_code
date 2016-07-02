Rails.application.routes.draw do

  mount GamesAdmin::Engine => "/games_admin"

  root to: "games_admin/games#index"
end
