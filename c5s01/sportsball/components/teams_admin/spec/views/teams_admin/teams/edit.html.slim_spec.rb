RSpec.describe "teams_admin/teams/edit", :type => :view do
  before(:each) do
    @team = assign(:team, TeamsStore::TeamRepository.new.create(Teams::Team.new(nil, "MyString")))
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", teams_admin.teams_team_path(@team.id), "post" do

      assert_select "input#teams_team_name[name=?]", "teams_team[name]"
    end
  end
end
