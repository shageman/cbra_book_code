RSpec.describe PredictorUi::PredictionsController, :type => :controller do
  routes { PredictorUi::Engine.routes }

  before do
    @team1 = create_team
    @team2 = create_team
  end

  describe "GET new" do
    it "assigns all teams as @teams" do
      get :new, {}, {}
      expect(assigns(:teams)).to eq([@team1, @team2])
    end
  end

  describe "POST create" do
    it "renders the prediction when the prediction succeeds"

    it "renders an error when the prediction failed"
  end
end
