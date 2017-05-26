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

ActiveRecord::Schema.define(version: 20170525183350) do

  create_table "losers", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "team_id"
    t.integer  "placar"
    t.string   "lado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_losers_on_round_id"
    t.index ["team_id"], name: "index_losers_on_team_id"
  end

  create_table "map_bans", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "map_id"
    t.index ["map_id"], name: "index_map_bans_on_map_id"
    t.index ["tournament_id"], name: "index_map_bans_on_tournament_id"
  end

  create_table "maps", force: :cascade do |t|
    t.string   "nome"
    t.string   "sigla"
    t.string   "imagem_uid"
    t.string   "imagem_name"
    t.boolean  "ativo",       default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "participants", force: :cascade do |t|
    t.integer "team_id"
    t.integer "tournament_id"
    t.index ["team_id"], name: "index_participants_on_team_id"
    t.index ["tournament_id"], name: "index_participants_on_tournament_id"
  end

  create_table "players", force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_players_on_team_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "ct_team_id"
    t.integer  "t_team_id"
    t.integer  "tournament_id"
    t.integer  "map_id"
    t.integer  "pontos",          default: 3
    t.string   "screenshot_uid"
    t.string   "screenshot_name"
    t.date     "data_round"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["map_id"], name: "index_rounds_on_map_id"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "kills",      default: 0
    t.integer  "deaths",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["round_id"], name: "index_statistics_on_round_id"
    t.index ["team_id"], name: "index_statistics_on_team_id"
    t.index ["user_id"], name: "index_statistics_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "nome"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "oficial",    default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nome"
    t.string   "login"
    t.string   "password_digest"
    t.string   "steamid"
    t.string   "email"
    t.boolean  "ativo",           default: true
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "winners", force: :cascade do |t|
    t.integer  "round_id"
    t.integer  "team_id"
    t.integer  "placar"
    t.string   "lado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_winners_on_round_id"
    t.index ["team_id"], name: "index_winners_on_team_id"
  end

end
