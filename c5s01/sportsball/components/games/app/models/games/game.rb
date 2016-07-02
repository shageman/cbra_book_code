module Games
  class Game < ActiveRecord::Base
    validates :date, :location, :first_team_id, :second_team_id, :winning_team,
              :first_team_score, :second_team_score, presence: true
    # belongs_to :first_team, class_name: 'Teams::TeamRepository::TeamRecord'
    # belongs_to :second_team, class_name: 'Teams::TeamRepository::TeamRecord'
  end
end
