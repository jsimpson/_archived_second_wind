class AddSpeedTrendToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :speed_trend, :integer, null: false, default: 0
  end
end
