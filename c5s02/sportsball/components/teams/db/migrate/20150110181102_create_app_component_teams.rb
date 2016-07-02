class CreateAppComponentTeams < ActiveRecord::Migration
  def change
    create_table :app_component_teams do |t|
      t.string :name

      t.timestamps
    end
  end
end
