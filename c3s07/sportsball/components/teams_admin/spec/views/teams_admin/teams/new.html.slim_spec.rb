RSpec.describe "teams_admin/teams/new", :type => :view do
  before(:each) do
    assign(:team, Teams::Team.new(
      :name => "MyString"
    ))
  end

  it "renders new team form" do
    render
    assert_select "form[action=?][method=?]", teams_admin.teams_path, "post" do
      assert_select "input#team_name[name=?]", "team[name]"
    end
  end
end
