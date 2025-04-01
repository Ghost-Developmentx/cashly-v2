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

ActiveRecord::Schema[8.0].define(version: 2025_04_01_215416) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "account_type"
    t.string "institution"
    t.string "account_number_last_four"
    t.decimal "balance", precision: 10, scale: 2
    t.decimal "available_balance", precision: 10, scale: 2
    t.string "currency"
    t.string "status"
    t.string "external_id"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "name"
    t.decimal "amount", precision: 10, scale: 2
    t.string "period"
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.boolean "rollover_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_budgets_on_category_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "name"
    t.text "description"
    t.string "category_type"
    t.string "icon"
    t.string "color"
    t.boolean "is_system", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "fin_conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "status"
    t.jsonb "context"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fin_conversations_on_user_id"
  end

  create_table "fin_message_references", force: :cascade do |t|
    t.bigint "fin_message_id", null: false
    t.string "referenced_entity_type", null: false
    t.bigint "referenced_entity_id", null: false
    t.string "reference_type"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fin_message_id"], name: "index_fin_message_references_on_fin_message_id"
    t.index ["referenced_entity_type", "referenced_entity_id"], name: "index_fin_message_references_on_referenced_entity"
  end

  create_table "fin_messages", force: :cascade do |t|
    t.bigint "fin_conversation_id", null: false
    t.text "content"
    t.string "role"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fin_conversation_id"], name: "index_fin_messages_on_fin_conversation_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "display_name"
    t.text "bio"
    t.string "avatar_url"
    t.string "phone_number"
    t.jsonb "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "description"
    t.string "merchant_name"
    t.date "transaction_date"
    t.date "posted_date"
    t.string "status"
    t.string "transaction_type"
    t.boolean "is_recurring"
    t.string "external_id"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "currency"
    t.string "language"
    t.string "timezone"
    t.jsonb "notification_preferences"
    t.jsonb "privacy_settings"
    t.jsonb "ui_preferences"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "budgets", "categories"
  add_foreign_key "budgets", "users"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "fin_conversations", "users"
  add_foreign_key "fin_message_references", "fin_messages"
  add_foreign_key "fin_messages", "fin_conversations"
  add_foreign_key "profiles", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "user_preferences", "users"
end
