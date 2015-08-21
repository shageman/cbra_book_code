
Rails.application.routes.draw do
  mount AppComponent::Engine, at: "/app_component"
  mount GamesAdmin::Engine, at: "/games_admin"

  root to: "app_component/welcomes#show"
end


