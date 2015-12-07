class AddCadenceToActivitiesAndLaps < ActiveRecord::Migration
  def change
    add_column :activities, :average_cadence, :integer
    add_column :activities, :max_cadence, :integer
    add_column :laps, :average_cadence, :integer
    add_column :laps, :maximum_cadence, :integer
  end
end
