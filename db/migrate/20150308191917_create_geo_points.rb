class CreateGeoPoints < ActiveRecord::Migration
  def change
    create_table :geo_points do |t|
      t.integer :activity_id
      t.integer :cadence
      t.decimal :distance
      t.decimal :elevation
      t.integer :heart_rate
      t.decimal :lat
      t.decimal :lng
      t.decimal :power
      t.decimal :speed
      t.datetime :time

      t.timestamps null: false
    end

    add_index :geo_points, :activity_id
  end
end
