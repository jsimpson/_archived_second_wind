class AddMaxSpeedAndMinSpeedToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :max_speed, :float
    add_column :activities, :min_speed, :float
  end
end
