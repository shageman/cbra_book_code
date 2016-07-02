Rails.application.routes.draw do

  mount TeamsAdmin::Engine => "/teams_admin"

  root to: "teams#index"
end
