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

ActiveRecord::Schema.define(version: 20140828004433) do

  create_table "menus", force: true do |t|
    t.string  "name"
    t.string  "url"
    t.integer "parent_id", default: 0, null: false
  end

  add_index "menus", ["parent_id"], name: "parent_id", using: :hash

  create_table "menus_roles", id: false, force: true do |t|
    t.integer "menu_id"
    t.integer "role_id"
  end

  add_index "menus_roles", ["role_id", "menu_id"], name: "role_menu", unique: true, using: :hash

  create_table "procedures", force: true do |t|
    t.string   "name",       limit: 100,                 null: false
    t.string   "desc",       limit: 100,                 null: false
    t.string   "type",       limit: 100,                 null: false
    t.boolean  "board",                  default: false, null: false
    t.boolean  "attachment",             default: false, null: false
    t.integer  "creator_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string "name", limit: 100, null: false
  end

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 100,                null: false
    t.integer  "department_id",                                     null: false
    t.integer  "role_id",                                           null: false
    t.boolean  "active",                             default: true, null: false
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                             null: false
    t.string   "encrypted_password",                 default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id", using: :hash
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :hash
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :hash

end
