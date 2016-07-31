RSpec.describe "teams_admin/teams/index", :type => :view do
  before :each do
    TeamsStore::TeamRepository.new.create(Teams::Team.new(nil, "MyString"))
    TeamsStore::TeamRepository.new.create(Teams::Team.new(nil, "MyString"))
    assign(:teams, TeamsStore::TeamRepository.new.get_all)
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "MyString", :count => 2
  end
end
