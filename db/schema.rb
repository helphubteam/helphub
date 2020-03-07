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

ActiveRecord::Schema.define(version: 2020_03_07_160846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer "kind", default: 0, null: false, comment: "Type of article"
    t.text "name", null: false, comment: "Article name"
    t.text "content", null: false, comment: "Article text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kind"], name: "index_articles_on_kind"
    t.index ["name"], name: "index_articles_on_name"
  end

  create_table "articles_stories", force: :cascade do |t|
    t.integer "article_id", null: false, comment: "Article ID"
    t.integer "story_id", null: false, comment: "Story ID"
  end

  create_table "stories", force: :cascade do |t|
    t.text "name", null: false, comment: "Story name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_stories_on_name", unique: true
  end

end
