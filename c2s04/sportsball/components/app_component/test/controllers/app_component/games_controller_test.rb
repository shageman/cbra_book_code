require 'test_helper'

module AppComponent
  class GamesControllerTest < ActionController::TestCase
    setup do
      @game = games(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:games)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create game" do
      assert_difference('Game.count') do
        post :create, game: { date: @game.date, first_team_id: @game.first_team_id, first_team_score: @game.first_team_score, location: @game.location, second_team_id: @game.second_team_id, second_team_score: @game.second_team_score, winning_team: @game.winning_team }
      end

      assert_redirected_to game_path(assigns(:game))
    end

    test "should show game" do
      get :show, id: @game
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @game
      assert_response :success
    end

    test "should update game" do
      patch :update, id: @game, game: { date: @game.date, first_team_id: @game.first_team_id, first_team_score: @game.first_team_score, location: @game.location, second_team_id: @game.second_team_id, second_team_score: @game.second_team_score, winning_team: @game.winning_team }
      assert_redirected_to game_path(assigns(:game))
    end

    test "should destroy game" do
      assert_difference('Game.count', -1) do
        delete :destroy, id: @game
      end

      assert_redirected_to games_path
    end
  end
end
