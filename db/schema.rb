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

ActiveRecord::Schema.define(version: 2019_10_10_085805) do

  create_table "actors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "age"
    t.string "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "directors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "age"
    t.string "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "media_actors", force: :cascade do |t|
    t.integer "media_id", null: false
    t.integer "actor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["actor_id"], name: "index_media_actors_on_actor_id"
    t.index ["media_id"], name: "index_media_actors_on_media_id"
  end

  create_table "media_genres", force: :cascade do |t|
    t.integer "media_id", null: false
    t.integer "genre_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["genre_id"], name: "index_media_genres_on_genre_id"
    t.index ["media_id"], name: "index_media_genres_on_media_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "media_id", null: false
    t.integer "status_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "zscore", default: 0.0, null: false
    t.index ["media_id"], name: "index_ratings_on_media_id"
    t.index ["status_id"], name: "index_ratings_on_status_id"
    t.index ["user_id", "media_id"], name: "index_ratings_on_user_id_and_media_id", unique: true
    t.index ["user_id", "status_id"], name: "index_ratings_on_user_id_and_status_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "label", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.string "remember_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rating_sum", default: 0, null: false
    t.integer "rating_sum_of_squares", default: 0, null: false
    t.integer "scored_ratings", default: 0, null: false
  end

  add_foreign_key "media_actors", "actors"
  add_foreign_key "media_actors", "media"
  add_foreign_key "media_genres", "genres"
  add_foreign_key "media_genres", "media"
  add_foreign_key "ratings", "statuses"
  add_foreign_key "ratings", "users"
end
