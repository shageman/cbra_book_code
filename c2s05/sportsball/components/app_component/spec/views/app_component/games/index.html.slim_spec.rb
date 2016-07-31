require 'rails_helper'

RSpec.describe "games/index", :type => :view do
  before :each do
    assign(:games, [
      Game.create!(
        :location => "Location",
        :first_team_id => 1,
        :second_team_id => 2,
        :winning_team => 3,
        :first_team_score => 4,
        :second_team_score => 5
      ),
      Game.create!(
        :location => "Location",
        :first_team_id => 1,
        :second_team_id => 2,
        :winning_team => 3,
        :first_team_score => 4,
        :second_team_score => 5
      )
    ])
  end

  it "renders a list of games" do
    render
    assert_select "tr>td", :text => "Location".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
