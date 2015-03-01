class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :type
      t.datetime :logged_date
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :total_elevation_gain
      t.decimal :total_elevation_loss
      t.integer :total_time
      t.decimal :total_distance
      t.decimal :average_speed
      t.decimal :average_pace
      t.decimal :max_elevation
      t.decimal :min_elevation
      t.integer :max_heart_rate
      t.integer :min_heart_rate
      t.integer :average_heart_rate
      t.integer :total_calories
      t.decimal :quality

      t.timestamps null: false
    end
  end
end
