module PredictorUi
  class PredictionsController < ApplicationController
    def new
      @teams = Teams::TeamRepository.new.get_all
    end

    def create
      game_predictor = PredictGame::PredictGame.new
      game_predictor.add_subscriber(PredictionResponse.new(self))
      game_predictor.perform(
          Teams::TeamRepository.new.get(params['first_team']['id']),
          Teams::TeamRepository.new.get(params['second_team']['id']))
    end

    class PredictionResponse < SimpleDelegator
      def prediction_succeeded(prediction)
        render locals: {prediction: prediction, message: nil}
      end

      def prediction_failed(prediction, error_message)
        render locals: {prediction: prediction, message: error_message}
      end
    end
  end
end
