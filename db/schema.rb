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

ActiveRecord::Schema[8.0].define(version: 2025_10_08_160505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "badges", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.string "badge_type"
    t.text "description"
    t.text "requirement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenge_badges", force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "badge_id", null: false
    t.text "requirement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_challenge_badges_on_badge_id"
    t.index ["challenge_id", "badge_id"], name: "index_challenge_badges_on_challenge_id_and_badge_id", unique: true
    t.index ["challenge_id"], name: "index_challenge_badges_on_challenge_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "start_day"
    t.date "end_day"
    t.text "point_rules"
    t.bigint "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_challenges_on_creator_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "user_id", null: false
    t.integer "points"
    t.date "date_start"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id", "user_id"], name: "index_participations_on_challenge_id_and_user_id", unique: true
    t.index ["challenge_id"], name: "index_participations_on_challenge_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "progress_entries", force: :cascade do |t|
    t.bigint "challenge_id", null: false
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "points"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id", "user_id", "date"], name: "index_progress_entries_on_challenge_id_and_user_id_and_date"
    t.index ["challenge_id"], name: "index_progress_entries_on_challenge_id"
    t.index ["user_id"], name: "index_progress_entries_on_user_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "badge_id", null: false
    t.datetime "awarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.date "birthday"
    t.string "nationality"
    t.string "gender"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "challenge_badges", "badges"
  add_foreign_key "challenge_badges", "challenges"
  add_foreign_key "challenges", "users", column: "creator_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "participations", "challenges"
  add_foreign_key "participations", "users"
  add_foreign_key "progress_entries", "challenges"
  add_foreign_key "progress_entries", "users"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
end
