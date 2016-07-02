RSpec.describe "teams_admin/teams/index", :type => :view do
  before(:each) do
    Teams::TeamRepository.new.create(Teams::Team.new(nil, "MyString"))
    Teams::TeamRepository.new.create(Teams::Team.new(nil, "MyString"))
    assign(:teams, Teams::TeamRepository.new.get_all)
  end

  it "renders a list of teams" do
    render
    assert_select "tr>td", :text => "MyString", :count => 2
  end
end
