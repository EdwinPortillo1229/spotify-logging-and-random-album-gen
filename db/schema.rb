# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_23_211710) do
  create_table "spotify_albums", force: :cascade do |t|
    t.string "artist"
    t.string "external_id"
    t.string "name"
    t.string "release_date"
    t.string "api_href"
    t.string "spotify_url"
    t.integer "total_tracks"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spotify_user_albums", force: :cascade do |t|
    t.integer "spotify_user_id", null: false
    t.integer "spotify_album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spotify_album_id"], name: "index_spotify_user_albums_on_spotify_album_id"
    t.index ["spotify_user_id", "spotify_album_id"], name: "index_spotify_user_albums_on_user_id_and_album_id", unique: true
    t.index ["spotify_user_id"], name: "index_spotify_user_albums_on_spotify_user_id"
  end

  create_table "spotify_users", force: :cascade do |t|
    t.string "display_name"
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
  end

  add_foreign_key "spotify_user_albums", "spotify_albums"
  add_foreign_key "spotify_user_albums", "spotify_users"
end
