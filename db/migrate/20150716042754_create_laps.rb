class CreateLaps < ActiveRecord::Migration
  def change
    create_table :laps do |t|
      t.integer :activity_id
      t.datetime :start_time
      t.integer :total_time
      t.decimal :distance
      t.integer :calories
      t.decimal :average_speed
      t.decimal :maximum_speed
      t.integer :average_heart_rate
      t.integer :maximum_heart_rate

      t.timestamps null: false
    end

    add_index :laps, :activity_id
  end
end
