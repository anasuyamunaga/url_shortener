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

ActiveRecord::Schema[8.1].define(version: 2024_01_01_000002) do
  create_table "links", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", default: "", null: false
    t.string "slug", null: false
    t.string "target_url", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_links_on_slug", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.boolean "bot", default: false, null: false
    t.string "ip_digest", limit: 64
    t.integer "link_id", null: false
    t.string "referrer", limit: 2048
    t.string "user_agent", limit: 512
    t.datetime "visited_at", null: false
    t.index ["link_id", "bot", "visited_at"], name: "index_visits_on_link_id_and_bot_and_visited_at"
    t.index ["link_id"], name: "index_visits_on_link_id"
  end

  add_foreign_key "visits", "links"
end
