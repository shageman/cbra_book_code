
class MoveGameFromAppComponentToGames < ActiveRecord::Migration
  def change
    rename_table :app_component_games, :games_games
  end
end


