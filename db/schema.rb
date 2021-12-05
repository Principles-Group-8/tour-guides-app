# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_05_021242) do

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tours", force: :cascade do |t|
    t.datetime "time", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "end_time", default: "2021-11-10 06:45:19", null: false
    t.integer "min_guides", null: false
    t.string "location", default: "HOG", null: false
    t.string "note"
    t.boolean "weekly", default: false, null: false
    t.integer "weeks"
    t.string "checked_in_email", default: "--- []\n"
  end

  create_table "tours_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tour_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "administrator", default: false, null: false
    t.boolean "mon_9", default: false, null: false
    t.boolean "mon_9:30", default: false, null: false
    t.boolean "mon_10", default: false, null: false
    t.boolean "mon_10:30", default: false, null: false
    t.boolean "mon_11", default: false, null: false
    t.boolean "mon_11:30", default: false, null: false
    t.boolean "mon_12", default: false, null: false
    t.boolean "mon_12:30", default: false, null: false
    t.boolean "mon_1", default: false, null: false
    t.boolean "mon_1:30", default: false, null: false
    t.boolean "mon_2", default: false, null: false
    t.boolean "mon_2:30", default: false, null: false
    t.boolean "mon_3", default: false, null: false
    t.boolean "mon_3:30", default: false, null: false
    t.boolean "mon_4", default: false, null: false
    t.boolean "mon_4:30", default: false, null: false
    t.boolean "mon_5", default: false, null: false
    t.boolean "mon_5:30", default: false, null: false
    t.boolean "tues_9", default: false, null: false
    t.boolean "tues_9:30", default: false, null: false
    t.boolean "tues_10", default: false, null: false
    t.boolean "tues_10:30", default: false, null: false
    t.boolean "tues_11", default: false, null: false
    t.boolean "tues_11:30", default: false, null: false
    t.boolean "tues_12", default: false, null: false
    t.boolean "tues_12:30", default: false, null: false
    t.boolean "tues_1", default: false, null: false
    t.boolean "tues_1:30", default: false, null: false
    t.boolean "tues_2", default: false, null: false
    t.boolean "tues_2:30", default: false, null: false
    t.boolean "tues_3", default: false, null: false
    t.boolean "tues_3:30", default: false, null: false
    t.boolean "tues_4", default: false, null: false
    t.boolean "tues_4:30", default: false, null: false
    t.boolean "tues_5", default: false, null: false
    t.boolean "tues_5:30", default: false, null: false
    t.boolean "wed_9", default: false, null: false
    t.boolean "wed_9:30", default: false, null: false
    t.boolean "wed_10", default: false, null: false
    t.boolean "wed_10:30", default: false, null: false
    t.boolean "wed_11", default: false, null: false
    t.boolean "wed_11:30", default: false, null: false
    t.boolean "wed_12", default: false, null: false
    t.boolean "wed_12:30", default: false, null: false
    t.boolean "wed_1", default: false, null: false
    t.boolean "wed_1:30", default: false, null: false
    t.boolean "wed_2", default: false, null: false
    t.boolean "wed_2:30", default: false, null: false
    t.boolean "wed_3", default: false, null: false
    t.boolean "wed_3:30", default: false, null: false
    t.boolean "wed_4", default: false, null: false
    t.boolean "wed_4:30", default: false, null: false
    t.boolean "wed_5", default: false, null: false
    t.boolean "wed_5:30", default: false, null: false
    t.boolean "thur_9", default: false, null: false
    t.boolean "thur_9:30", default: false, null: false
    t.boolean "thur_10", default: false, null: false
    t.boolean "thur_10:30", default: false, null: false
    t.boolean "thur_11", default: false, null: false
    t.boolean "thur_11:30", default: false, null: false
    t.boolean "thur_12", default: false, null: false
    t.boolean "thur_12:30", default: false, null: false
    t.boolean "thur_1", default: false, null: false
    t.boolean "thur_1:30", default: false, null: false
    t.boolean "thur_2", default: false, null: false
    t.boolean "thur_2:30", default: false, null: false
    t.boolean "thur_3", default: false, null: false
    t.boolean "thur_3:30", default: false, null: false
    t.boolean "thur_4", default: false, null: false
    t.boolean "thur_4:30", default: false, null: false
    t.boolean "thur_5", default: false, null: false
    t.boolean "thur_5:30", default: false, null: false
    t.boolean "fri_9", default: false, null: false
    t.boolean "fri_9:30", default: false, null: false
    t.boolean "fri_10", default: false, null: false
    t.boolean "fri_10:30", default: false, null: false
    t.boolean "fri_11", default: false, null: false
    t.boolean "fri_11:30", default: false, null: false
    t.boolean "fri_12", default: false, null: false
    t.boolean "fri_12:30", default: false, null: false
    t.boolean "fri_1", default: false, null: false
    t.boolean "fri_1:30", default: false, null: false
    t.boolean "fri_2", default: false, null: false
    t.boolean "fri_2:30", default: false, null: false
    t.boolean "fri_3", default: false, null: false
    t.boolean "fri_3:30", default: false, null: false
    t.boolean "fri_4", default: false, null: false
    t.boolean "fri_4:30", default: false, null: false
    t.boolean "fri_5", default: false, null: false
    t.boolean "fri_5:30", default: false, null: false
    t.boolean "sat_9", default: false, null: false
    t.boolean "sat_9:30", default: false, null: false
    t.boolean "sat_10", default: false, null: false
    t.boolean "sat_10:30", default: false, null: false
    t.boolean "sat_11", default: false, null: false
    t.boolean "sat_11:30", default: false, null: false
    t.boolean "sat_12", default: false, null: false
    t.boolean "sat_12:30", default: false, null: false
    t.boolean "sat_1", default: false, null: false
    t.boolean "sat_1:30", default: false, null: false
    t.boolean "sat_2", default: false, null: false
    t.boolean "sat_2:30", default: false, null: false
    t.boolean "sat_3", default: false, null: false
    t.boolean "sat_3:30", default: false, null: false
    t.boolean "sat_4", default: false, null: false
    t.boolean "sat_4:30", default: false, null: false
    t.boolean "sat_5", default: false, null: false
    t.boolean "sat_5:30", default: false, null: false
    t.boolean "sun_9", default: false, null: false
    t.boolean "sun_9:30", default: false, null: false
    t.boolean "sun_10", default: false, null: false
    t.boolean "sun_10:30", default: false, null: false
    t.boolean "sun_11", default: false, null: false
    t.boolean "sun_11:30", default: false, null: false
    t.boolean "sun_12", default: false, null: false
    t.boolean "sun_12:30", default: false, null: false
    t.boolean "sun_1", default: false, null: false
    t.boolean "sun_1:30", default: false, null: false
    t.boolean "sun_2", default: false, null: false
    t.boolean "sun_2:30", default: false, null: false
    t.boolean "sun_3", default: false, null: false
    t.boolean "sun_3:30", default: false, null: false
    t.boolean "sun_4", default: false, null: false
    t.boolean "sun_4:30", default: false, null: false
    t.boolean "sun_5", default: false, null: false
    t.boolean "sun_5:30", default: false, null: false
    t.string "first_name", default: "First", null: false
    t.string "last_name", default: "Last", null: false
    t.integer "points", default: 0, null: false
    t.integer "absences", default: 0
  end

end
