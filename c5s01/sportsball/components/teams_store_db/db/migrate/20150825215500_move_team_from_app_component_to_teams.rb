
class MoveTeamFromAppComponentToTeams < ActiveRecord::Migration
  def change
    rename_table :app_component_teams, :teams_teams
  end
end


