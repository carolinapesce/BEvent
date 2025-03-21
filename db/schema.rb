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

ActiveRecord::Schema[8.0].define(version: 2025_03_17_113448) do
  create_table "charity_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donations", force: :cascade do |t|
    t.string "donation_id", null: false
    t.integer "event_id", null: false
    t.integer "user_id", null: false
    t.float "amount", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
    t.boolean "anonymous"
    t.index ["event_id"], name: "index_donations_on_event_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "current_participants"
    t.string "address"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "max_participants"
    t.string "charity_id"
    t.string "beneficiary"
    t.decimal "fundraiser_goal", precision: 10, scale: 2
    t.decimal "current_funds", precision: 10, scale: 2, default: "0.0"
    t.string "city"
    t.string "country"
    t.integer "status", default: 0
  end

  create_table "favourites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.index ["event_id"], name: "index_favourites_on_event_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "ticket_id", null: false
    t.float "price", null: false
    t.string "seat_number"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "booked_datetime"
    t.integer "event_id"
    t.index ["event_id"], name: "index_tickets_on_event_id"
    t.index ["user_id", "event_id"], name: "index_tickets_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "phone_number"
    t.string "uid"
    t.string "image_url"
    t.string "provider"
    t.integer "role"
    t.text "bio"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "donations", "events"
  add_foreign_key "donations", "users"
  add_foreign_key "favourites", "events"
  add_foreign_key "favourites", "users"
  add_foreign_key "tickets", "events"
  add_foreign_key "tickets", "users"
end
