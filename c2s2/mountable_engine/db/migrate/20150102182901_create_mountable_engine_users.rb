class CreateMountableEngineUsers < ActiveRecord::Migration
  def change
    create_table :mountable_engine_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
