

require "slim-rails"
require "jquery-rails"

require "web_ui"
require "teams_store"
require "games"
require "predict_game"

module PredictorUi
  require "predictor_ui/engine"

  def self.nav_entry
    {name: "Predictions", link: -> {::PredictorUi::Engine.routes.url_helpers.new_prediction_path}}
  end
end


