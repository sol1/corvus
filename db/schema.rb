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

ActiveRecord::Schema.define(version: 20150714000000) do

  create_table "calls", force: :cascade do |t|
    t.integer  "cdr_id",                limit: 4,   null: false
    t.datetime "calldate"
    t.datetime "callend"
    t.integer  "duration",              limit: 4
    t.integer  "connect_duration",      limit: 4
    t.string   "caller",                limit: 255
    t.string   "callername",            limit: 255
    t.integer  "called_id",             limit: 4
    t.string   "whohanged",             limit: 255
    t.integer  "bye",                   limit: 4
    t.string   "last_sip_response",     limit: 255
    t.integer  "last_sip_response_num", limit: 4
    t.integer  "id_sensor",             limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "calls", ["calldate"], name: "index_calls_on_calldate", using: :btree
  add_index "calls", ["called_id"], name: "index_calls_on_called_id", using: :btree
  add_index "calls", ["cdr_id"], name: "index_calls_on_cdr_id", unique: true, using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "call_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "inbound_numbers", force: :cascade do |t|
    t.string   "number",     limit: 255
    t.string   "label",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "inbound_numbers", ["label"], name: "index_inbound_numbers_on_label", using: :btree
  add_index "inbound_numbers", ["number"], name: "index_inbound_numbers_on_number", unique: true, using: :btree

  create_table "number_ranges", force: :cascade do |t|
    t.integer  "parent_id",  limit: 4
    t.string   "start",      limit: 255
    t.string   "end",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "type",       limit: 32,  default: "TeamNumberRange"
  end

  add_index "number_ranges", ["parent_id"], name: "index_number_ranges_on_parent_id", using: :btree

  create_table "ratings", force: :cascade do |t|
    t.integer  "call_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "rating",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "calldate"
  end

  create_table "teams", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "manager",                limit: 1,   default: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.integer  "team_id",                limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["team_id"], name: "index_users_on_team_id", using: :btree

  add_foreign_key "users", "teams"
end
