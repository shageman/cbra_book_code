Rails.application.routes.draw do
  mount WelcomeUi::Engine, at: "/welcome_ui"
  mount GamesAdmin::Engine, at: "/games_admin"
  mount TeamsAdmin::Engine, at: "/teams_admin"
  mount PredictorUi::Engine, at: "/predictor_ui"

  root to: "welcome_ui/welcomes#show"
end
