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

ActiveRecord::Schema[7.0].define(version: 2023_10_04_074138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loyalty_stats", force: :cascade do |t|
    t.integer "customer_id"
    t.bigint "tier_id", null: false
    t.integer "total_spent_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_loyalty_stats_on_customer_id"
    t.index ["tier_id"], name: "index_loyalty_stats_on_tier_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id"
    t.integer "total_in_cents"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["date"], name: "index_orders_on_date"
  end

  create_table "tiers", force: :cascade do |t|
    t.string "name"
    t.integer "min_spent_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "loyalty_stats", "tiers"
end
