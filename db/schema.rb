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

ActiveRecord::Schema.define(version: 20151207113455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.string   "key",         null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image"
  end

  create_table "achievements_users", force: :cascade do |t|
    t.integer  "achievement_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "achievements_users", ["achievement_id"], name: "index_achievements_users_on_achievement_id", using: :btree
  add_index "achievements_users", ["user_id"], name: "index_achievements_users_on_user_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lounges", force: :cascade do |t|
    t.string   "title"
    t.integer  "city_id"
    t.string   "color"
    t.string   "blazon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "active"
  end

  add_index "lounges", ["city_id"], name: "index_lounges_on_city_id", using: :btree

  create_table "meets", force: :cascade do |t|
    t.integer  "reservation_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "meets", ["reservation_id"], name: "index_meets_on_reservation_id", using: :btree
  add_index "meets", ["user_id"], name: "index_meets_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "table_id"
  end

  add_index "payments", ["table_id"], name: "index_payments_on_table_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "penalties", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "slug"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "penalties_users", force: :cascade do |t|
    t.integer "penalty_id"
    t.integer "user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "table_id"
    t.datetime "visit_date"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.binary   "idrref"
    t.integer  "client_count"
    t.string   "duration"
    t.datetime "end_visit_date"
  end

  add_index "reservations", ["table_id"], name: "index_reservations_on_table_id", using: :btree
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id", using: :btree

  create_table "skill_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "skill_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "skill_anc_desc_idx", unique: true, using: :btree
  add_index "skill_hierarchies", ["descendant_id"], name: "skill_desc_idx", using: :btree

  create_table "skills", force: :cascade do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
    t.string   "ancestry"
    t.integer  "cost",        default: 1
    t.integer  "parent_id"
    t.integer  "role"
    t.integer  "row"
  end

  create_table "skills_links", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
  end

  add_index "skills_links", ["child_id"], name: "skill_child_idx", using: :btree
  add_index "skills_links", ["parent_id", "child_id"], name: "skill_links_idx", unique: true, using: :btree

  create_table "skills_users", force: :cascade do |t|
    t.integer  "skill_id"
    t.integer  "user_id"
    t.datetime "used_at"
  end

  create_table "tables", force: :cascade do |t|
    t.string   "title"
    t.integer  "lounge_id"
    t.integer  "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "vip"
  end

  add_index "tables", ["lounge_id"], name: "index_tables_on_lounge_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",                             default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                              default: 0
    t.string   "phone"
    t.string   "phone_token"
    t.decimal  "experience",                                     default: 0.0
    t.integer  "level",                                          default: 1
    t.integer  "skill_point",                                    default: 0
    t.string   "avatar"
    t.string   "auth_token"
    t.string   "email"
    t.decimal  "spent_money",            precision: 8, scale: 2
    t.binary   "idrref"
  end

  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["phone_token"], name: "index_users_on_phone_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "works", force: :cascade do |t|
    t.integer  "lounge_id"
    t.integer  "user_id"
    t.datetime "work_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "works", ["lounge_id"], name: "index_works_on_lounge_id", using: :btree
  add_index "works", ["user_id"], name: "index_works_on_user_id", using: :btree

  add_foreign_key "achievements_users", "achievements"
  add_foreign_key "achievements_users", "users"
  add_foreign_key "lounges", "cities"
  add_foreign_key "meets", "reservations"
  add_foreign_key "meets", "users"
  add_foreign_key "payments", "tables"
  add_foreign_key "payments", "users"
  add_foreign_key "reservations", "tables"
  add_foreign_key "reservations", "users"
  add_foreign_key "tables", "lounges"
  add_foreign_key "works", "lounges"
  add_foreign_key "works", "users"
end
