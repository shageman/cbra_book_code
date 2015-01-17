require 'rails_helper'

RSpec.describe "games/show", :type => :view do
  before(:each) do
    @game = assign(:game, Game.create!(
      :location => "Location",
      :first_team_id => 1,
      :second_team_id => 2,
      :winning_team => 3,
      :first_team_score => 4,
      :second_team_score => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
