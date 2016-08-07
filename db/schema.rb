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

ActiveRecord::Schema.define(version: 20160807213852) do

  create_table "items", force: :cascade do |t|
    t.string   "item_id"
    t.integer  "count"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string   "poke_id"
    t.string   "move_1"
    t.string   "move_2"
    t.integer  "max_health"
    t.integer  "attack"
    t.integer  "defense"
    t.integer  "stamina"
    t.integer  "cp"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.decimal  "iv"
    t.string   "nickname"
    t.integer  "favorite"
    t.integer  "num_upgrades"
    t.integer  "battles_attacked"
    t.integer  "battles_defended"
    t.string   "pokeball"
    t.decimal  "height_m"
    t.decimal  "weight_kg"
    t.integer  "health"
    t.integer  "poke_num"
    t.integer  "candy"
    t.float    "creation_time_ms"
    t.index ["user_id"], name: "index_pokemons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "screen_name"
    t.integer  "level"
    t.integer  "experience"
    t.integer  "prev_level_xp"
    t.integer  "next_level_xp"
    t.integer  "pokemons_encountered"
    t.decimal  "km_walked"
    t.integer  "pokemons_captured"
    t.integer  "poke_stop_visits"
    t.integer  "pokeballs_thrown"
    t.integer  "battle_attack_won"
    t.integer  "battle_attack_total"
    t.integer  "battle_defended_won"
    t.integer  "prestige_rasied_total"
    t.integer  "pokemon_deployed"
    t.integer  "prestige_dropped_total"
    t.integer  "eggs_hatched"
    t.integer  "evolutions"
    t.integer  "unique_pokedex_entries"
    t.string   "refresh_token"
    t.float    "access_token_expire_time"
    t.string   "team"
    t.string   "max_pokemon_storage"
    t.string   "max_item_storage"
    t.float    "POKECOIN"
    t.float    "STARDUST"
    t.string   "last_data_update"
  end

end
