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

ActiveRecord::Schema.define(version: 20140912071552) do

  create_table "board_heads", force: true do |t|
    t.string   "name",                       null: false
    t.string   "remark",     default: "",    null: false
    t.string   "board_type", default: "",    null: false
    t.string   "cols",       default: "",    null: false
    t.string   "rows",       default: "",    null: false
    t.boolean  "with_date",  default: false, null: false
    t.boolean  "available",  default: true,  null: false
    t.integer  "creator_id", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "board_heads", ["name", "board_type"], name: "board_type_name", unique: true, using: :btree

  create_table "clients", force: true do |t|
    t.string   "name",       default: "", null: false
    t.integer  "company_id", default: 0,  null: false
    t.string   "email",      default: "", null: false
    t.string   "address",    default: "", null: false
    t.string   "tel",        default: "", null: false
    t.text     "remark",                  null: false
    t.integer  "creator_id",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["company_id"], name: "company_id", using: :btree
  add_index "clients", ["email"], name: "email", using: :btree
  add_index "clients", ["name"], name: "name", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name",                                              null: false
    t.string   "code",                                              null: false
    t.integer  "parent_id",                           default: 0,   null: false
    t.decimal  "price",      precision: 10, scale: 2, default: 0.0, null: false
    t.string   "full_name",                                         null: false
    t.integer  "creator_id",                          default: 0,   null: false
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
    t.text    "remark"
  end

  add_index "menus", ["parent_id"], name: "parent_id", using: :btree

  create_table "menus_roles", id: false, force: true do |t|
    t.integer "menu_id", null: false
    t.integer "role_id", null: false
  end

  add_index "menus_roles", ["role_id", "menu_id"], name: "role_menu", unique: true, using: :btree

  create_table "orders", force: true do |t|
    t.integer  "client_id",                           null: false
    t.integer  "day_number",          default: 1,     null: false
    t.integer  "board_head_id",                       null: false
    t.integer  "parent_id",           default: 0,     null: false
    t.date     "receive_date",                        null: false
    t.string   "sn",                                  null: false
    t.boolean  "urgent",              default: false, null: false
    t.boolean  "is_test",             default: false, null: false
    t.string   "transport_condition", default: "",    null: false
    t.string   "status",              default: "",    null: false
    t.text     "remark"
    t.integer  "creator_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["client_id"], name: "client_id", using: :btree
  add_index "orders", ["parent_id"], name: "parent_id", using: :btree
  add_index "orders", ["receive_date"], name: "receive_date", using: :btree
  add_index "orders", ["sn"], name: "sn", unique: true, using: :btree

  create_table "primer_boards", force: true do |t|
    t.integer  "board_head_id", null: false
    t.date     "create_date",   null: false
    t.integer  "number",        null: false
    t.string   "sn",            null: false
    t.integer  "creator_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "primer_boards", ["board_head_id"], name: "board_head_id", using: :btree
  add_index "primer_boards", ["create_date"], name: "create_date", using: :btree
  add_index "primer_boards", ["sn"], name: "sn", unique: true, using: :btree

  create_table "primers", force: true do |t|
    t.string   "name",                                                      null: false
    t.decimal  "origin_thickness", precision: 10, scale: 2, default: 5.0,   null: false
    t.string   "annealing",                                 default: "",    null: false
    t.text     "seq"
    t.integer  "client_id",                                 default: 0,     null: false
    t.integer  "primer_board_id",                           default: 0,     null: false
    t.string   "hole",                                      default: "",    null: false
    t.string   "status",                                    default: "",    null: false
    t.string   "store_type",                                default: "",    null: false
    t.date     "receive_date",                                              null: false
    t.date     "expire_date",                                               null: false
    t.date     "operate_date",                                              null: false
    t.boolean  "need_return",                               default: false, null: false
    t.boolean  "available",                                 default: true,  null: false
    t.text     "remark"
    t.integer  "creator_id",                                default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedures", force: true do |t|
    t.string  "name",                   default: "",       null: false
    t.string  "remark",                 default: "",       null: false
    t.string  "flow_type",  limit: 100, default: "sample", null: false
    t.boolean "board",                  default: false,    null: false
    t.boolean "attachment",             default: false,    null: false
    t.integer "creator_id",             default: 0,        null: false
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

  create_table "vectors", force: true do |t|
    t.string   "name",        null: false
    t.string   "producer",    null: false
    t.string   "length",      null: false
    t.string   "resistance",  null: false
    t.string   "copy_number", null: false
    t.integer  "creator_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vectors", ["name"], name: "name", using: :btree

end
