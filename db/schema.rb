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

ActiveRecord::Schema.define(version: 20180107205030) do

  create_table "binanceprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "bitfinexprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "bittrexprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string   "job_id",            limit: 255,        null: false
    t.text     "log",               limit: 4294967295
    t.datetime "last_performed_at"
    t.boolean  "healthy",           limit: 1
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "crono_jobs", ["job_id"], name: "index_crono_jobs_on_job_id", unique: true, using: :btree

  create_table "domains", force: :cascade do |t|
    t.string   "company_id",   limit: 255
    t.string   "company_name", limit: 255
    t.string   "address",      limit: 255
    t.string   "city",         limit: 255
    t.string   "country",      limit: 255
    t.string   "zip_code",     limit: 255
    t.string   "tax_office",   limit: 255
    t.string   "vat_number",   limit: 255
    t.string   "telephone1",   limit: 255
    t.string   "telephone2",   limit: 255
    t.string   "fax1",         limit: 255
    t.string   "fax2",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "exmoprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "gateprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "hitbtcprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "krakenprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "okexprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "poloprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_token",  limit: 255
    t.integer  "domain_id",       limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "zbprices", force: :cascade do |t|
    t.text     "eth",        limit: 65535
    t.text     "btc",        limit: 65535
    t.text     "bch",        limit: 65535
    t.text     "ltc",        limit: 65535
    t.text     "dash",       limit: 65535
    t.text     "etc",        limit: 65535
    t.text     "zec",        limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
