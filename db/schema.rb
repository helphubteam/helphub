# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_02_201439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "help_request_logs", force: :cascade do |t|
    t.text "comment"
    t.bigint "help_request_id", null: false
    t.integer "kind", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["help_request_id"], name: "index_help_request_logs_on_help_request_id"
    t.index ["user_id"], name: "index_help_request_logs_on_user_id"
  end

  create_table "help_requests", force: :cascade do |t|
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}, null: false
    t.string "phone"
    t.integer "state", default: 0, null: false
    t.text "comment"
    t.string "person"
    t.boolean "mediated", default: false, null: false
    t.boolean "meds_preciption_required"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "volunteer_id"
    t.string "city"
    t.string "district"
    t.string "street"
    t.string "house"
    t.string "apartment"
    t.bigint "organization_id"
    t.geography "lonlat_with_salt", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.string "number"
    t.date "schedule_set_at"
    t.index ["organization_id"], name: "index_help_requests_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "title", null: false
    t.string "country"
    t.string "city"
    t.string "site"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.bigint "organization_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "help_requests", "organizations"
  add_foreign_key "users", "organizations"
end
