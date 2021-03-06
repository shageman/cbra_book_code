RSpec.describe "Engine 'App'", :type => :feature do
  it "hooks up to /" do
    visit "/"
    within "main h1" do
      expect(page).to have_content 'Sportsball'
    end
  end

  it "has teams" do
    visit "/"
    click_link "Teams"
    within "main h1" do
      expect(page).to have_content 'Teams'
    end
  end

  it "has games" do
    visit "/"
    click_link "Games"
    within "main h1" do
      expect(page).to have_content 'Games'
    end
  end

  it "can predict" do
    TeamsStore::TeamRepository.new.create Teams::Team.new(nil, "UofL")
    TeamsStore::TeamRepository.new.create Teams::Team.new(nil, "UK")

    visit "/"
    click_link "Predictions"
    click_button "What is it going to be"
  end
end
