require 'test_helper'

module AppComponent
  class WelcomeControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end

  end
end
