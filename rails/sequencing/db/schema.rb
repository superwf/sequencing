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

ActiveRecord::Schema.define(version: 20140905061853) do

  create_table "companies", force: true do |t|
    t.string   "name",                                  null: false
    t.string   "code",                                  null: false
    t.integer  "parent_id",               default: 0,   null: false
    t.string   "price",                   default: "0", null: false
    t.string   "DECIMAL(10, 2) UNSIGNED", default: "0", null: false
    t.string   "full_name",                             null: false
    t.integer  "creator_id",              default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["code"], name: "code", using: :btree
  add_index "companies", ["name"], name: "name", using: :btree
  add_index "companies", ["parent_id"], name: "parent_id", using: :btree

  create_table "menus", force: true do |t|
    t.string  "name",      default: "", null: false
    t.string  "url",       default: "", null: false
    t.integer "parent_id", default: 0,  null: false
    t.text    "remark",                 null: false
  end

  add_index "menus", ["parent_id"], name: "parent_id", using: :btree

  create_table "menus_roles", id: false, force: true do |t|
    t.integer "menu_id", null: false
    t.integer "role_id", null: false
  end

  add_index "menus_roles", ["role_id", "menu_id"], name: "role_menu", unique: true, using: :btree

  create_table "procedures", force: true do |t|
    t.string   "name",       limit: 100, default: "",       null: false
    t.string   "remark",     limit: 100, default: "",       null: false
    t.string   "flow_type",  limit: 100, default: "sample", null: false
    t.boolean  "board",                  default: false,    null: false
    t.boolean  "attachment",             default: false,    null: false
    t.integer  "creator_id",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", id: false, force: true do |t|
    t.integer  "id",                     default: 0, null: false
    t.string   "name",       limit: 100,             null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.text     "remark"
  end

  create_table "sample_heads", force: true do |t|
    t.string  "name",                          null: false
    t.string  "remark",        default: "",    null: false
    t.boolean "auto_precheck", default: false, null: false
    t.boolean "available",     default: true,  null: false
    t.integer "creator_id",    default: 0,     null: false
  end

  create_table "users", id: false, force: true do |t|
    t.integer  "id",                                 default: 0,    null: false
    t.string   "name",                   limit: 100,                null: false
    t.string   "signature"
    t.integer  "department_id"
    t.integer  "role_id"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "email",                                             null: false
    t.string   "encrypted_password",                 default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.boolean  "active",                             default: true, null: false
  end

end
