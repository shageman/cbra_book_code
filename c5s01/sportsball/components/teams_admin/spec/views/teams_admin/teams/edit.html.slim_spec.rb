RSpec.describe "teams_admin/teams/edit", :type => :view do
  before(:each) do
    @team = assign(:team, Teams::TeamRepository.new.create(Teams::Team.new(nil, "MyString")))
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", teams_admin.team_path(@team.id), "post" do

      assert_select "input#team_name[name=?]", "team[name]"
    end
  end
end
