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

ActiveRecord::Schema.define(version: 2018_06_24_082444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cumulative_games", force: :cascade do |t|
    t.bigint "player_id"
    t.string "nhl_id"
    t.date "date"
    t.integer "goals"
    t.integer "assists"
    t.integer "hits"
    t.integer "blocks"
    t.integer "shots"
    t.integer "points"
    t.integer "pim"
    t.integer "ppg"
    t.integer "ppa"
    t.integer "ppp"
    t.integer "shg"
    t.integer "sha"
    t.integer "shp"
    t.integer "gwg"
    t.integer "otg"
    t.integer "plus_minus"
    t.integer "toi"
    t.integer "mss"
    t.integer "gva"
    t.integer "tka"
    t.integer "fow"
    t.integer "fot"
    t.integer "fol"
    t.integer "gp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_cumulative_games_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "nhl_id"
    t.date "birth_date"
    t.integer "years_in_league"
    t.boolean "lw"
    t.boolean "rw"
    t.boolean "c"
    t.boolean "d"
    t.boolean "g"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "division"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cumulative_games", "players"
  add_foreign_key "players", "teams"
end
