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

ActiveRecord::Schema.define(version: 20171218103937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coin_sessions", force: :cascade do |t|
    t.bigint "trade_process_id"
    t.bigint "coin_id"
    t.date "end_date"
    t.float "amount_in_crypto"
    t.bigint "previous_coin_id"
    t.bigint "next_coin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "running"
    t.float "last_known_value"
    t.index ["coin_id"], name: "index_coin_sessions_on_coin_id"
    t.index ["next_coin_id"], name: "index_coin_sessions_on_next_coin_id"
    t.index ["previous_coin_id"], name: "index_coin_sessions_on_previous_coin_id"
    t.index ["trade_process_id"], name: "index_coin_sessions_on_trade_process_id"
  end

  create_table "coin_updates", force: :cascade do |t|
    t.bigint "coin_session_id"
    t.integer "percent_change_1h"
    t.integer "percent_change_24h"
    t.integer "percent_change_7d"
    t.integer "price_in_euro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_session_id"], name: "index_coin_updates_on_coin_session_id"
  end

  create_table "coins", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.integer "last_known_price_in_euros"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "coin_sessions_count"
    t.string "coin_market_id"
  end

  create_table "rest_amounts", force: :cascade do |t|
    t.bigint "trade_process_id"
    t.float "amount", default: 0.0
    t.integer "amount_of_transactions", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_process_id"], name: "index_rest_amounts_on_trade_process_id"
  end

  create_table "session_logs", force: :cascade do |t|
    t.text "change_log"
    t.bigint "coin_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_session_id"], name: "index_session_logs_on_coin_session_id"
  end

  create_table "trade_processes", force: :cascade do |t|
    t.date "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "coin_sessions", "coins"
  add_foreign_key "coin_sessions", "trade_processes"
  add_foreign_key "coin_updates", "coin_sessions"
  add_foreign_key "rest_amounts", "trade_processes"
  add_foreign_key "session_logs", "coin_sessions"
end
