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

ActiveRecord::Schema[7.1].define(version: 2024_03_24_152152) do
  create_table "finance_terms", force: :cascade do |t|
    t.decimal "downpayment"
    t.decimal "amt_financed"
    t.datetime "due_date"
    t.boolean "is_accepted", default: false
    t.integer "insurance_policies_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insurance_policies_id"], name: "index_finance_terms_on_insurance_policies_id"
  end

  create_table "insurance_policies", force: :cascade do |t|
    t.decimal "premium"
    t.decimal "tax_fee"
    t.integer "insureds_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insureds_id"], name: "index_insurance_policies_on_insureds_id"
  end

  create_table "insureds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "finance_terms", "insurance_policies", column: "insurance_policies_id"
  add_foreign_key "insurance_policies", "insureds", column: "insureds_id"
end
