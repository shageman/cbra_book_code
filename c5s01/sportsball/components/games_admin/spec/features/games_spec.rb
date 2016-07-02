RSpec.describe "games admin", :type => :feature do
  before :each do
    team1 = create_team name: "UofL"
    team2 = create_team name: "UK"

    create_game first_team_id: team1.id, second_team_id: team2.id, winning_team: 1
  end

  it "allows for the management of games" do
    visit '/games_admin/games'

    click_link "Games"

    expect(page).to have_content 'Somewhere'
  end
end
