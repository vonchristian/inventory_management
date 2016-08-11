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

ActiveRecord::Schema.define(version: 20160811071029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "house_number"
    t.string   "street"
    t.string   "barangay"
    t.string   "municipality"
    t.string   "province"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_addresses_on_user_id", using: :btree
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.decimal  "number"
    t.integer  "discount_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "order_id"
    t.decimal  "quantity",     default: "1.0"
    t.decimal  "unit_cost"
    t.decimal  "total_cost"
    t.integer  "pricing_type", default: 0
    t.integer  "user_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
    t.index ["product_id"], name: "index_line_items_on_product_id", using: :btree
    t.index ["user_id"], name: "index_line_items_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "pay_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "delivery_type"
    t.string   "receipt_number"
    t.integer  "user_id"
    t.date     "date"
    t.decimal  "cash_tendered"
    t.decimal  "change"
    t.decimal  "tax_amount"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",             precision: 9, scale: 2
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "unit"
    t.integer  "category_id"
    t.boolean  "alert"
    t.integer  "alert_number"
    t.decimal  "wholesale_price"
    t.decimal  "stock_alert_count"
    t.string   "bar_code"
    t.integer  "stock_status"
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
  end

  create_table "refunds", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "reason"
    t.integer  "request_status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.decimal  "quantity",       precision: 8, scale: 2
    t.datetime "date"
    t.integer  "product_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.decimal  "purchase_price"
    t.index ["product_id"], name: "index_stocks_on_product_id", using: :btree
  end

  create_table "taxes", force: :cascade do |t|
    t.integer  "tax_type"
    t.string   "name"
    t.decimal  "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type"
    t.string   "mobile"
    t.string   "full_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["type"], name: "index_users_on_type", using: :btree
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "users"
  add_foreign_key "stocks", "products"
end
