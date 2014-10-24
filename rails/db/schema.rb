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

ActiveRecord::Schema.define(version: 20141017024940) do

  create_table "bill_orders", primary_key: "order_id", force: true do |t|
    t.integer "bill_id",                                             null: false
    t.decimal "price",        precision: 10, scale: 2, default: 0.0, null: false
    t.decimal "money",        precision: 10, scale: 2, default: 0.0, null: false
    t.decimal "other_money",  precision: 10, scale: 2, default: 0.0, null: false
    t.integer "charge_count",                          default: 0,   null: false
    t.string  "remark"
  end

  add_index "bill_orders", ["bill_id"], name: "bill_id", using: :btree

  create_table "bill_records", primary_key: "bill_id", force: true do |t|
    t.text     "data",       null: false
    t.integer  "creator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: true do |t|
    t.date     "create_date",                                        null: false
    t.integer  "number",                               default: 1,   null: false
    t.string   "sn",                                                 null: false
    t.decimal  "money",       precision: 10, scale: 2, default: 0.0, null: false
    t.decimal  "other_money", precision: 10, scale: 2, default: 0.0, null: false
    t.string   "status",                                             null: false
    t.integer  "creator_id",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bills", ["sn"], name: "sn", unique: true, using: :btree

  create_table "board_heads", force: true do |t|
    t.string   "name",                       null: false
    t.string   "remark",     default: "",    null: false
    t.string   "board_type", default: "",    null: false
    t.string   "cols",       default: "",    null: false
    t.string   "rows",       default: "",    null: false
    t.boolean  "with_date",  default: false, null: false
    t.boolean  "available",  default: true,  null: false
    t.boolean  "is_redo",    default: false, null: false
    t.integer  "creator_id", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "board_heads", ["board_type", "name"], name: "board_type_name", unique: true, using: :btree
  add_index "board_heads", ["name"], name: "name", using: :btree

  create_table "board_records", force: true do |t|
    t.integer  "board_id",     null: false
    t.integer  "procedure_id", null: false
    t.integer  "creator_id",   null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "board_records", ["board_id", "procedure_id"], name: "board_procedure", using: :btree

  create_table "boards", force: true do |t|
    t.integer "board_head_id",                            null: false
    t.integer "procedure_id",             default: 0,     null: false
    t.integer "number",                   default: 1
    t.date    "create_date",                              null: false
    t.string  "status",                   default: "new", null: false
    t.string  "sn",            limit: 50,                 null: false
  end

  add_index "boards", ["board_head_id"], name: "board_head_id", using: :btree
  add_index "boards", ["create_date"], name: "create_date", using: :btree
  add_index "boards", ["sn"], name: "sn", unique: true, using: :btree

  create_table "client_reactions", force: true do |t|
    t.string   "sample",                           null: false
    t.string   "sample_type",      default: "",    null: false
    t.string   "structure",        default: "",    null: false
    t.integer  "client_id",                        null: false
    t.string   "fragment",         default: "",    null: false
    t.string   "vector",           default: "",    null: false
    t.string   "resistance",       default: "",    null: false
    t.string   "primer",           default: "",    null: false
    t.boolean  "universal_primer", default: false, null: false
    t.boolean  "is_splice",        default: false, null: false
    t.string   "remark",           default: "",    null: false
    t.integer  "reaction_id",      default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_reactions", ["client_id"], name: "client_id", using: :btree
  add_index "client_reactions", ["reaction_id"], name: "reaction_id", using: :btree
  add_index "client_reactions", ["sample"], name: "sample", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name",               default: "", null: false
    t.integer  "company_id",         default: 0,  null: false
    t.string   "email",              default: "", null: false
    t.string   "address",            default: "", null: false
    t.string   "tel",                default: "", null: false
    t.text     "remark",                          null: false
    t.integer  "creator_id",                      null: false
    t.string   "encrypted_password", default: "", null: false
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
    t.string   "full_code",                                         null: false
    t.integer  "creator_id",                          default: 0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["code"], name: "code", using: :btree
  add_index "companies", ["name"], name: "name", using: :btree
  add_index "companies", ["parent_id"], name: "parent_id", using: :btree

  create_table "dilute_primers", force: true do |t|
    t.integer  "primer_id",  default: 0,  null: false
    t.string   "status",                  null: false
    t.string   "remark",     default: "", null: false
    t.integer  "creator_id", default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dilute_primers", ["created_at"], name: "created_at", using: :btree
  add_index "dilute_primers", ["primer_id"], name: "primer_id", using: :btree

  create_table "emails", force: true do |t|
    t.integer  "record_id",  default: 0,     null: false
    t.boolean  "sent",       default: false, null: false
    t.string   "email_type",                 null: false
    t.string   "remark",     default: "",    null: false
    t.integer  "creator_id", default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["record_id", "email_type"], name: "record_id", using: :btree
  add_index "emails", ["sent"], name: "sent", using: :btree

  create_table "flows", force: true do |t|
    t.integer "board_head_id", null: false
    t.integer "procedure_id",  null: false
  end

  add_index "flows", ["board_head_id", "procedure_id"], name: "board_procedure", unique: true, using: :btree
  add_index "flows", ["procedure_id"], name: "procedure_id", using: :btree

  create_table "interprete_codes", force: true do |t|
    t.string   "code",                          null: false
    t.string   "result",                        null: false
    t.string   "remark",                        null: false
    t.boolean  "available",     default: true,  null: false
    t.boolean  "charge",        default: false, null: false
    t.integer  "board_head_id", default: 0,     null: false
    t.integer  "creator_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "number",              default: 1,     null: false
    t.integer  "board_head_id",                       null: false
    t.date     "create_date",                         null: false
    t.string   "sn",                                  null: false
    t.boolean  "urgent",              default: false, null: false
    t.boolean  "is_test",             default: false, null: false
    t.string   "transport_condition", default: "",    null: false
    t.string   "status",              default: "new", null: false
    t.text     "remark"
    t.integer  "creator_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["client_id"], name: "client_id", using: :btree
  add_index "orders", ["create_date"], name: "create_date", using: :btree
  add_index "orders", ["sn"], name: "sn", unique: true, using: :btree

  create_table "plasmid_codes", force: true do |t|
    t.string   "code",                      null: false
    t.string   "remark",                    null: false
    t.boolean  "available",  default: true, null: false
    t.integer  "creator_id", default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plasmid_codes", ["code"], name: "code", unique: true, using: :btree

  create_table "plasmids", primary_key: "sample_id", force: true do |t|
    t.integer  "code_id",    null: false
    t.integer  "creator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "precheck_codes", force: true do |t|
    t.string   "code",                      null: false
    t.boolean  "ok",         default: true, null: false
    t.boolean  "available",  default: true, null: false
    t.string   "remark",     default: "",   null: false
    t.integer  "creator_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prechecks", primary_key: "sample_id", force: true do |t|
    t.integer  "code_id",    null: false
    t.integer  "creator_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "primers", force: true do |t|
    t.string   "name",                                                      null: false
    t.decimal  "origin_thickness", precision: 10, scale: 2, default: 5.0,   null: false
    t.string   "annealing",                                 default: "",    null: false
    t.text     "seq"
    t.integer  "client_id",                                 default: 0,     null: false
    t.integer  "board_id",                                  default: 0,     null: false
    t.string   "hole",                                      default: "",    null: false
    t.string   "status",                                    default: "ok",  null: false
    t.string   "store_type",                                default: "",    null: false
    t.date     "create_date",                                               null: false
    t.date     "expire_date",                                               null: false
    t.date     "operate_date",                                              null: false
    t.boolean  "need_return",                               default: false, null: false
    t.boolean  "available",                                 default: true,  null: false
    t.text     "remark"
    t.integer  "creator_id",                                default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "primers", ["board_id", "hole"], name: "board_hole", unique: true, using: :btree
  add_index "primers", ["client_id"], name: "client_id", using: :btree
  add_index "primers", ["name"], name: "name", using: :btree

  create_table "procedures", force: true do |t|
    t.string  "name",                    default: "",       null: false
    t.string  "record_name",             default: "",       null: false
    t.string  "remark",                  default: "",       null: false
    t.string  "flow_type",   limit: 100, default: "sample", null: false
    t.boolean "board",                   default: false,    null: false
    t.integer "creator_id",              default: 0,        null: false
  end

  add_index "procedures", ["name"], name: "name", unique: true, using: :btree

  create_table "reaction_files", primary_key: "reaction_id", force: true do |t|
    t.datetime "uploaded_at"
    t.integer  "code_id",        default: 0,  null: false
    t.string   "proposal",       default: "", null: false
    t.string   "status",                      null: false
    t.integer  "interpreter_id", default: 0,  null: false
    t.datetime "interpreted_at"
  end

  add_index "reaction_files", ["code_id"], name: "code_id", using: :btree
  add_index "reaction_files", ["interpreter_id"], name: "interpreter_id", using: :btree
  add_index "reaction_files", ["status"], name: "status", using: :btree

  create_table "reactions", force: true do |t|
    t.integer "order_id",                      null: false
    t.integer "sample_id",                     null: false
    t.integer "primer_id",                     null: false
    t.integer "dilute_primer_id", default: 0,  null: false
    t.integer "board_id"
    t.string  "hole",             default: ""
    t.integer "parent_id",        default: 0
    t.text    "remark"
  end

  add_index "reactions", ["board_id", "hole"], name: "board_hole", using: :btree
  add_index "reactions", ["dilute_primer_id"], name: "dilute_primer_id", using: :btree
  add_index "reactions", ["order_id"], name: "order_id", using: :btree
  add_index "reactions", ["primer_id"], name: "primer_id", using: :btree
  add_index "reactions", ["sample_id", "primer_id"], name: "sample_primer", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string "name", limit: 100, null: false
  end

  create_table "samples", force: true do |t|
    t.string  "name",                          null: false
    t.integer "order_id",                      null: false
    t.integer "vector_id",     default: 0
    t.string  "fragment",      default: "0",   null: false
    t.string  "resistance",    default: "",    null: false
    t.string  "return_type",   default: "",    null: false
    t.integer "board_id",      default: 0
    t.string  "hole",          default: "",    null: false
    t.boolean "is_splice",     default: false, null: false
    t.string  "splice_status", default: "",    null: false
    t.boolean "is_through",    default: false, null: false
    t.integer "parent_id",     default: 0
  end

  add_index "samples", ["board_id", "hole"], name: "board_hole", using: :btree
  add_index "samples", ["order_id", "name"], name: "order_id", unique: true, using: :btree

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

  add_index "users", ["department_id"], name: "index_users_on_department_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

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
