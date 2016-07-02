
require "slim-rails"
require "jquery-rails"

require "predictor"
require "app_component"
require "teams"

module PredictorUi
  require "predictor_ui/engine"

  def self.nav_entry
    {name: "Predictions", link: -> {::PredictorUi::Engine.routes.url_helpers.new_prediction_path}}
  end
end


