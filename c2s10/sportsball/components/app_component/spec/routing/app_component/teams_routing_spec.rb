RSpec.describe AppComponent::TeamsController, :type => :routing do
  routes { AppComponent::Engine.routes }

  it "routes to #index" do
    expect(:get => "/teams").to route_to("app_component/teams#index")
  end

  it "routes to #new" do
    expect(:get => "/teams/new").to route_to("app_component/teams#new")
  end

  it "routes to #show" do
    expect(:get => "/teams/1").to route_to("app_component/teams#show", :id => "1")
  end

  it "routes to #edit" do
    expect(:get => "/teams/1/edit").to route_to("app_component/teams#edit", :id => "1")
  end

  it "routes to #create" do
    expect(:post => "/teams").to route_to("app_component/teams#create")
  end

  it "routes to #update" do
    expect(:put => "/teams/1").to route_to("app_component/teams#update", :id => "1")
  end

  it "routes to #destroy" do
    expect(:delete => "/teams/1").to route_to("app_component/teams#destroy", :id => "1")
  end
end
