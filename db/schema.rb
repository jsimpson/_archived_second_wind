# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150718181954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.decimal  "total_elevation_gain"
    t.decimal  "total_elevation_loss"
    t.integer  "total_time"
    t.decimal  "total_distance"
    t.decimal  "average_speed"
    t.decimal  "max_elevation"
    t.decimal  "min_elevation"
    t.integer  "max_heart_rate"
    t.integer  "min_heart_rate"
    t.integer  "average_heart_rate"
    t.decimal  "quality"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "geo_route_file_name"
    t.string   "geo_route_content_type"
    t.integer  "geo_route_file_size"
    t.datetime "geo_route_updated_at"
    t.float    "max_speed"
    t.float    "min_speed"
    t.integer  "total_calories"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "full_address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "country_code"
  end

  create_table "geo_points", force: :cascade do |t|
    t.integer  "activity_id"
    t.integer  "cadence"
    t.decimal  "distance"
    t.decimal  "elevation"
    t.integer  "heart_rate"
    t.decimal  "lat"
    t.decimal  "lng"
    t.decimal  "power"
    t.decimal  "speed"
    t.datetime "time"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "geo_points", ["activity_id"], name: "index_geo_points_on_activity_id", using: :btree

  create_table "laps", force: :cascade do |t|
    t.integer  "activity_id"
    t.datetime "start_time"
    t.integer  "total_time"
    t.decimal  "distance"
    t.integer  "calories"
    t.decimal  "average_speed"
    t.decimal  "maximum_speed"
    t.integer  "average_heart_rate"
    t.integer  "maximum_heart_rate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "laps", ["activity_id"], name: "index_laps_on_activity_id", using: :btree

end
