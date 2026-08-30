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

ActiveRecord::Schema[8.1].define(version: 2026_08_29_193841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_addons_on_restaurant_id"
    t.check_constraint "price >= 0::numeric", name: "addons_price_non_negative"
  end

  create_table "business_hours", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.time "close_time"
    t.datetime "created_at", null: false
    t.integer "day_of_week", null: false
    t.time "open_time"
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id", "day_of_week"], name: "index_business_hours_on_restaurant_id_and_day_of_week", unique: true
    t.index ["restaurant_id"], name: "index_business_hours_on_restaurant_id"
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_categories_on_restaurant_id"
  end

  create_table "order_item_addons", force: :cascade do |t|
    t.bigint "addon_id", null: false
    t.string "addon_name", null: false
    t.datetime "created_at", null: false
    t.bigint "order_item_id", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_order_item_addons_on_addon_id"
    t.index ["order_item_id"], name: "index_order_item_addons_on_order_item_id"
    t.check_constraint "price >= 0::numeric", name: "order_item_addons_price_non_negative"
    t.check_constraint "quantity > 0", name: "order_item_addons_quantity_positive"
    t.check_constraint "subtotal >= 0::numeric", name: "order_item_addons_subtotal_non_negative"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "observation"
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.string "product_name", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.check_constraint "quantity > 0", name: "order_items_quantity_positive"
    t.check_constraint "subtotal >= 0::numeric", name: "order_items_subtotal_non_negative"
    t.check_constraint "unit_price >= 0::numeric", name: "order_items_unit_price_non_negative"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "customer_name", null: false
    t.string "customer_phone", null: false
    t.bigint "restaurant_id", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
    t.check_constraint "total >= 0::numeric", name: "orders_total_non_negative"
  end

  create_table "product_addons", force: :cascade do |t|
    t.bigint "addon_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_product_addons_on_addon_id"
    t.index ["product_id", "addon_id"], name: "index_product_addons_on_product_id_and_addon_id", unique: true
    t.index ["product_id"], name: "index_product_addons_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["restaurant_id"], name: "index_products_on_restaurant_id"
    t.check_constraint "price >= 0::numeric", name: "products_price_non_negative"
  end

  create_table "restaurants", force: :cascade do |t|
    t.boolean "accepting_orders", default: true, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.string "whatsapp", null: false
    t.index ["slug"], name: "index_restaurants_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["restaurant_id"], name: "index_users_on_restaurant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addons", "restaurants"
  add_foreign_key "business_hours", "restaurants"
  add_foreign_key "categories", "restaurants"
  add_foreign_key "order_item_addons", "addons"
  add_foreign_key "order_item_addons", "order_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "product_addons", "addons"
  add_foreign_key "product_addons", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "restaurants"
  add_foreign_key "users", "restaurants"
end
