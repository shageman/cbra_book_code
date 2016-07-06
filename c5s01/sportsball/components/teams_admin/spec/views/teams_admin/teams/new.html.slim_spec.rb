RSpec.describe "teams_admin/teams/new", :type => :view do
  before(:each) do
    assign(:team, Teams::Team.new(nil, "MyString"))
  end

  it "renders new team form" do
    render
    assert_select "form[action=?][method=?]", teams_admin.teams_teams_path, "post" do
      assert_select "input#teams_team_name[name=?]", "teams_team[name]"
    end
  end
end
