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

ActiveRecord::Schema.define(version: 20150301084632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "type"
    t.datetime "logged_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "total_elevation_gain"
    t.decimal  "total_elevation_loss"
    t.integer  "total_time"
    t.decimal  "total_distance"
    t.decimal  "average_speed"
    t.decimal  "average_pace"
    t.decimal  "max_elevation"
    t.decimal  "min_elevation"
    t.integer  "max_heart_rate"
    t.integer  "min_heart_rate"
    t.integer  "average_heart_rate"
    t.integer  "total_calories"
    t.decimal  "quality"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end