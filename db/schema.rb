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

ActiveRecord::Schema.define(version: 20170929172124) do

  create_table "games", force: :cascade do |t|
    t.string   "nome"
    t.boolean  "ativo",      default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "sigla"
    t.string   "login"
  end

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
    t.integer  "game_id"
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

  create_table "random_maps", force: :cascade do |t|
    t.integer  "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_random_maps_on_map_id"
  end

  create_table "rankme_csgos", force: :cascade do |t|
    t.string   "steam"
    t.string   "name"
    t.string   "lastip"
    t.integer  "score"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "assists"
    t.integer  "suicides"
    t.integer  "tk"
    t.integer  "shots"
    t.integer  "hits"
    t.integer  "headshots"
    t.integer  "connected"
    t.integer  "rounds_tr"
    t.integer  "rounds_ct"
    t.integer  "lastconnect"
    t.integer  "knife"
    t.integer  "glock"
    t.integer  "hkp2000"
    t.integer  "usp_silencer"
    t.integer  "p250"
    t.integer  "deagle"
    t.integer  "elite"
    t.integer  "fiveseven"
    t.integer  "tec9"
    t.integer  "cz75a"
    t.integer  "revolver"
    t.integer  "nova"
    t.integer  "xm1014"
    t.integer  "mag7"
    t.integer  "sawedoff"
    t.integer  "bizon"
    t.integer  "mac10"
    t.integer  "mp9"
    t.integer  "mp7"
    t.integer  "ump45"
    t.integer  "p90"
    t.integer  "galilar"
    t.integer  "ak47"
    t.integer  "scar20"
    t.integer  "famas"
    t.integer  "m4a1"
    t.integer  "m4a1_silencer"
    t.integer  "aug"
    t.integer  "ssg08"
    t.integer  "sg556"
    t.integer  "awp"
    t.integer  "g3sg1"
    t.integer  "m249"
    t.integer  "negev"
    t.integer  "hegrenade"
    t.integer  "flashbang"
    t.integer  "smokegrenade"
    t.integer  "inferno"
    t.integer  "decoy"
    t.integer  "taser"
    t.integer  "head"
    t.integer  "chest"
    t.integer  "stomach"
    t.integer  "left_arm"
    t.integer  "right_arm"
    t.integer  "left_leg"
    t.integer  "right_leg"
    t.integer  "c4_planted"
    t.integer  "c4_exploded"
    t.integer  "c4_defused"
    t.integer  "ct_win"
    t.integer  "tr_win"
    t.integer  "hostages_rescued"
    t.integer  "vip_killed"
    t.integer  "vip_escaped"
    t.integer  "vip_played"
    t.integer  "mvp"
    t.integer  "damage"
    t.integer  "user_id"
    t.integer  "map_id"
    t.integer  "tournament_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "round_id"
    t.integer  "team_id"
    t.integer  "season_id"
  end

  create_table "rankmes", force: :cascade do |t|
    t.string   "steam"
    t.string   "name"
    t.string   "lastip"
    t.integer  "score"
    t.integer  "kills"
    t.integer  "deaths"
    t.integer  "suicides"
    t.integer  "tk"
    t.integer  "shots"
    t.integer  "hits"
    t.integer  "headshots"
    t.integer  "connected"
    t.integer  "rounds_tr"
    t.integer  "rounds_ct"
    t.integer  "lastconnect"
    t.integer  "knife"
    t.integer  "glock"
    t.integer  "usp"
    t.integer  "p228"
    t.integer  "deagle"
    t.integer  "elite"
    t.integer  "fiveseven"
    t.integer  "m3"
    t.integer  "xm1014"
    t.integer  "mac10"
    t.integer  "tmp"
    t.integer  "mp5navy"
    t.integer  "ump45"
    t.integer  "p90"
    t.integer  "galil"
    t.integer  "ak47"
    t.integer  "sg550"
    t.integer  "famas"
    t.integer  "m4a1"
    t.integer  "aug"
    t.integer  "scout"
    t.integer  "sg552"
    t.integer  "awp"
    t.integer  "g3sg1"
    t.integer  "m249"
    t.integer  "hegrenade"
    t.integer  "flashbang"
    t.integer  "smokegrenade"
    t.integer  "head"
    t.integer  "chest"
    t.integer  "stomach"
    t.integer  "left_arm"
    t.integer  "right_arm"
    t.integer  "left_leg"
    t.integer  "right_leg"
    t.integer  "c4_planted"
    t.integer  "c4_exploded"
    t.integer  "c4_defused"
    t.integer  "ct_win"
    t.integer  "tr_win"
    t.integer  "hostages_rescued"
    t.integer  "vip_killed"
    t.integer  "vip_escaped"
    t.integer  "vip_played"
    t.integer  "user_id"
    t.integer  "map_id"
    t.integer  "tournament_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "round_id"
    t.integer  "team_id"
    t.integer  "season_id"
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
    t.integer  "season_id"
    t.index ["map_id"], name: "index_rounds_on_map_id"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "nome"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "ativo",      default: true
  end

  create_table "server_configurations", force: :cascade do |t|
    t.string   "nome"
    t.string   "numero_partidas"
    t.boolean  "ativo",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
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
    t.integer  "season_id"
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
    t.string   "steam"
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
