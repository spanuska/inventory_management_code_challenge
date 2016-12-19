# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161219015505) do

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "warehouse_id"
  end

  add_index "orders", ["warehouse_id"], name: "index_orders_on_warehouse_id"

  create_table "orders_upcs", id: false, force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "upc_id",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer  "allocator_id"
    t.string   "allocator_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "upc_id"
  end

  add_index "products", ["allocator_type", "allocator_id"], name: "index_products_on_allocator_type_and_allocator_id"
  add_index "products", ["upc_id"], name: "index_products_on_upc_id"

  create_table "shipments", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "warehouse_id"
  end

  add_index "shipments", ["warehouse_id"], name: "index_shipments_on_warehouse_id"

  create_table "upcs", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warehouses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
