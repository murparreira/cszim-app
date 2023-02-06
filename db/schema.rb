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

ActiveRecord::Schema.define(version: 2023_02_04_311931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "demos", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.integer "map_id"
    t.boolean "processada", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_demos_on_map_id"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.boolean "ativo", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sigla"
    t.string "login"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "losers", id: :serial, force: :cascade do |t|
    t.integer "round_id"
    t.integer "team_id"
    t.integer "placar"
    t.string "lado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_losers_on_round_id"
    t.index ["team_id"], name: "index_losers_on_team_id"
  end

  create_table "map_bans", id: :serial, force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "map_id"
    t.index ["map_id"], name: "index_map_bans_on_map_id"
    t.index ["tournament_id"], name: "index_map_bans_on_tournament_id"
  end

  create_table "maps", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.string "imagem_uid"
    t.string "imagem_name"
    t.boolean "ativo", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
  end

  create_table "participants", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "tournament_id"
    t.index ["team_id"], name: "index_participants_on_team_id"
    t.index ["tournament_id"], name: "index_participants_on_tournament_id"
  end

  create_table "player_kills", id: :serial, force: :cascade do |t|
    t.boolean "attackerBlinded"
    t.string "attackerSide"
    t.string "victimSteamID"
    t.float "distance"
    t.boolean "isFirstKill"
    t.boolean "isWallbang"
    t.boolean "noScope"
    t.boolean "thruSmoke"
    t.boolean "victimBlinded"
    t.string "weapon"
    t.string "weaponClass"
    t.integer "player_statistic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_statistic_id"], name: "index_player_kills_on_player_statistic_id"
  end

  create_table "player_statistics", id: :serial, force: :cascade do |t|
    t.float "accuracy"
    t.float "adr"
    t.integer "assists"
    t.integer "attempts1v1"
    t.integer "attempts1v2"
    t.integer "attempts1v3"
    t.integer "attempts1v4"
    t.integer "attempts1v5"
    t.float "blindTime"
    t.integer "deaths"
    t.integer "defuses"
    t.integer "enemiesFlashed"
    t.integer "fireThrown"
    t.integer "firstDeaths"
    t.integer "firstKills"
    t.integer "flashAssists"
    t.integer "flashesThrown"
    t.integer "heThrown"
    t.integer "hs"
    t.float "hsPercent"
    t.float "kast"
    t.float "kdr"
    t.integer "kills"
    t.integer "kills0"
    t.integer "kills1"
    t.integer "kills2"
    t.integer "kills3"
    t.integer "kills4"
    t.integer "kills5"
    t.integer "plants"
    t.float "rating"
    t.integer "shotsHit"
    t.integer "smokesThrown"
    t.integer "success1v1"
    t.integer "success1v2"
    t.integer "success1v3"
    t.integer "success1v4"
    t.integer "success1v5"
    t.integer "suicides"
    t.integer "teamKills"
    t.integer "teammatesFlashed"
    t.integer "totalDamageGiven"
    t.integer "totalDamageTaken"
    t.integer "totalRounds"
    t.integer "totalShots"
    t.integer "totalTeamDamageGiven"
    t.integer "tradeKills"
    t.integer "tradedDeaths"
    t.integer "utilityDamage"
    t.integer "user_id"
    t.integer "demo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demo_id"], name: "index_player_statistics_on_demo_id"
    t.index ["user_id"], name: "index_player_statistics_on_user_id"
  end

  create_table "players", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.index ["team_id"], name: "index_players_on_team_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "random_maps", id: :serial, force: :cascade do |t|
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_random_maps_on_map_id"
  end

  create_table "rankme_csgos", id: :serial, force: :cascade do |t|
    t.string "steam"
    t.string "name"
    t.string "lastip"
    t.integer "score"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "suicides"
    t.integer "tk"
    t.integer "shots"
    t.integer "hits"
    t.integer "headshots"
    t.integer "connected"
    t.integer "rounds_tr"
    t.integer "rounds_ct"
    t.integer "lastconnect"
    t.integer "knife"
    t.integer "glock"
    t.integer "hkp2000"
    t.integer "usp_silencer"
    t.integer "p250"
    t.integer "deagle"
    t.integer "elite"
    t.integer "fiveseven"
    t.integer "tec9"
    t.integer "cz75a"
    t.integer "revolver"
    t.integer "nova"
    t.integer "xm1014"
    t.integer "mag7"
    t.integer "sawedoff"
    t.integer "bizon"
    t.integer "mac10"
    t.integer "mp9"
    t.integer "mp7"
    t.integer "ump45"
    t.integer "p90"
    t.integer "galilar"
    t.integer "ak47"
    t.integer "scar20"
    t.integer "famas"
    t.integer "m4a1"
    t.integer "m4a1_silencer"
    t.integer "aug"
    t.integer "ssg08"
    t.integer "sg556"
    t.integer "awp"
    t.integer "g3sg1"
    t.integer "m249"
    t.integer "negev"
    t.integer "hegrenade"
    t.integer "flashbang"
    t.integer "smokegrenade"
    t.integer "inferno"
    t.integer "decoy"
    t.integer "taser"
    t.integer "head"
    t.integer "chest"
    t.integer "stomach"
    t.integer "left_arm"
    t.integer "right_arm"
    t.integer "left_leg"
    t.integer "right_leg"
    t.integer "c4_planted"
    t.integer "c4_exploded"
    t.integer "c4_defused"
    t.integer "ct_win"
    t.integer "tr_win"
    t.integer "hostages_rescued"
    t.integer "vip_killed"
    t.integer "vip_escaped"
    t.integer "vip_played"
    t.integer "mvp"
    t.integer "damage"
    t.integer "user_id"
    t.integer "map_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id"
    t.integer "team_id"
    t.integer "season_id"
    t.integer "match_win"
    t.integer "match_draw"
    t.integer "match_lose"
    t.integer "mp5sd"
    t.integer "breachcharge"
    t.integer "first_blood"
    t.integer "no_scope"
    t.integer "no_scope_dis"
    t.integer "thru_smoke"
    t.integer "blind"
    t.integer "assist_flash"
    t.integer "assist_team_flash"
    t.integer "assist_team_kill"
    t.integer "wallbang"
  end

  create_table "rankmes", id: :serial, force: :cascade do |t|
    t.string "steam"
    t.string "name"
    t.string "lastip"
    t.integer "score"
    t.integer "kills"
    t.integer "deaths"
    t.integer "suicides"
    t.integer "tk"
    t.integer "shots"
    t.integer "hits"
    t.integer "headshots"
    t.integer "connected"
    t.integer "rounds_tr"
    t.integer "rounds_ct"
    t.integer "lastconnect"
    t.integer "knife"
    t.integer "glock"
    t.integer "usp"
    t.integer "p228"
    t.integer "deagle"
    t.integer "elite"
    t.integer "fiveseven"
    t.integer "m3"
    t.integer "xm1014"
    t.integer "mac10"
    t.integer "tmp"
    t.integer "mp5navy"
    t.integer "ump45"
    t.integer "p90"
    t.integer "galil"
    t.integer "ak47"
    t.integer "sg550"
    t.integer "famas"
    t.integer "m4a1"
    t.integer "aug"
    t.integer "scout"
    t.integer "sg552"
    t.integer "awp"
    t.integer "g3sg1"
    t.integer "m249"
    t.integer "hegrenade"
    t.integer "flashbang"
    t.integer "smokegrenade"
    t.integer "head"
    t.integer "chest"
    t.integer "stomach"
    t.integer "left_arm"
    t.integer "right_arm"
    t.integer "left_leg"
    t.integer "right_leg"
    t.integer "c4_planted"
    t.integer "c4_exploded"
    t.integer "c4_defused"
    t.integer "ct_win"
    t.integer "tr_win"
    t.integer "hostages_rescued"
    t.integer "vip_killed"
    t.integer "vip_escaped"
    t.integer "vip_played"
    t.integer "user_id"
    t.integer "map_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id"
    t.integer "team_id"
    t.integer "season_id"
  end

  create_table "rounds", id: :serial, force: :cascade do |t|
    t.integer "ct_team_id"
    t.integer "t_team_id"
    t.integer "tournament_id"
    t.integer "map_id"
    t.integer "pontos", default: 3
    t.string "screenshot_uid"
    t.string "screenshot_name"
    t.date "data_round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_id"
    t.index ["map_id"], name: "index_rounds_on_map_id"
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ativo", default: true
  end

  create_table "server_configurations", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "numero_partidas"
    t.boolean "ativo", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "server_name_or_ip"
    t.integer "server_port"
    t.text "server_password"
    t.text "server_user"
  end

  create_table "statistics", id: :serial, force: :cascade do |t|
    t.integer "round_id"
    t.integer "user_id"
    t.integer "team_id"
    t.integer "kills", default: 0
    t.integer "deaths", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_statistics_on_round_id"
    t.index ["team_id"], name: "index_statistics_on_team_id"
    t.index ["user_id"], name: "index_statistics_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "oficial", default: false
    t.integer "season_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "login"
    t.string "password_digest"
    t.string "steamid"
    t.string "email"
    t.boolean "ativo", default: true
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "steam"
    t.string "old_steam"
  end

  create_table "winners", id: :serial, force: :cascade do |t|
    t.integer "round_id"
    t.integer "team_id"
    t.integer "placar"
    t.string "lado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_winners_on_round_id"
    t.index ["team_id"], name: "index_winners_on_team_id"
  end

end
