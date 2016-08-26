RSpec.describe "app_component/teams/index", :type => :view do
  before :each do
    assign :teams, [
                     AppComponent::Team.create!(:name => "Name"),
                     AppComponent::Team.create!(:name => "Name")
                 ]
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
