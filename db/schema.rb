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

ActiveRecord::Schema.define(version: 20171010025614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_domain_blocks", force: :cascade do |t|
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id", "domain"], name: "index_account_domain_blocks_on_account_id_and_domain", unique: true
  end

  create_table "account_moderation_notes", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "account_id", null: false
    t.bigint "target_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_moderation_notes_on_account_id"
    t.index ["target_account_id"], name: "index_account_moderation_notes_on_target_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "domain"
    t.string "secret", default: "", null: false
    t.text "private_key"
    t.text "public_key", default: "", null: false
    t.string "remote_url", default: "", null: false
    t.string "salmon_url", default: "", null: false
    t.string "hub_url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note", default: "", null: false
    t.string "display_name", default: "", null: false
    t.string "uri", default: "", null: false
    t.string "url"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "header_file_name"
    t.string "header_content_type"
    t.integer "header_file_size"
    t.datetime "header_updated_at"
    t.string "avatar_remote_url"
    t.datetime "subscription_expires_at"
    t.boolean "silenced", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.boolean "locked", default: false, null: false
    t.string "header_remote_url", default: "", null: false
    t.integer "statuses_count", default: 0, null: false
    t.integer "followers_count", default: 0, null: false
    t.integer "following_count", default: 0, null: false
    t.datetime "last_webfingered_at"
    t.string "inbox_url", default: "", null: false
    t.string "outbox_url", default: "", null: false
    t.string "shared_inbox_url", default: "", null: false
    t.string "followers_url", default: "", null: false
    t.integer "protocol", default: 0, null: false
    t.index "(((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::\"char\") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::\"char\")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::\"char\")))", name: "search_index", using: :gin
    t.index "lower((username)::text), lower((domain)::text)", name: "index_accounts_on_username_and_domain_lower"
    t.index ["uri"], name: "index_accounts_on_uri"
    t.index ["url"], name: "index_accounts_on_url"
    t.index ["username", "domain"], name: "index_accounts_on_username_and_domain", unique: true
  end

  create_table "blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "target_account_id", null: false
    t.index ["account_id", "target_account_id"], name: "index_blocks_on_account_id_and_target_account_id", unique: true
  end

  create_table "conversation_mutes", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.bigint "account_id", null: false
    t.index ["account_id", "conversation_id"], name: "index_conversation_mutes_on_account_id_and_conversation_id", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uri"], name: "index_conversations_on_uri", unique: true
  end

  create_table "custom_emojis", force: :cascade do |t|
    t.string "shortcode", default: "", null: false
    t.string "domain"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disabled", default: false, null: false
    t.string "uri"
    t.string "image_remote_url"
    t.index ["shortcode", "domain"], name: "index_custom_emojis_on_shortcode_and_domain", unique: true
  end

  create_table "domain_blocks", force: :cascade do |t|
    t.string "domain", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "severity", default: 0
    t.boolean "reject_media", default: false, null: false
    t.index ["domain"], name: "index_domain_blocks_on_domain", unique: true
  end

  create_table "email_domain_blocks", force: :cascade do |t|
    t.string "domain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favourites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "status_id", null: false
    t.index ["account_id", "id"], name: "index_favourites_on_account_id_and_id"
    t.index ["account_id", "status_id"], name: "index_favourites_on_account_id_and_status_id", unique: true
    t.index ["status_id"], name: "index_favourites_on_status_id"
  end

  create_table "follow_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "target_account_id", null: false
    t.index ["account_id", "target_account_id"], name: "index_follow_requests_on_account_id_and_target_account_id", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "target_account_id", null: false
    t.index ["account_id", "target_account_id"], name: "index_follows_on_account_id_and_target_account_id", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.integer "type", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "data_file_name"
    t.string "data_content_type"
    t.integer "data_file_size"
    t.datetime "data_updated_at"
    t.bigint "account_id", null: false
  end

  create_table "media_attachments", force: :cascade do |t|
    t.bigint "status_id"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.string "remote_url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shortcode"
    t.integer "type", default: 0, null: false
    t.json "file_meta"
    t.bigint "account_id"
    t.text "description"
    t.index ["account_id"], name: "index_media_attachments_on_account_id"
    t.index ["shortcode"], name: "index_media_attachments_on_shortcode", unique: true
    t.index ["status_id"], name: "index_media_attachments_on_status_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.bigint "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.index ["account_id", "status_id"], name: "index_mentions_on_account_id_and_status_id", unique: true
    t.index ["status_id"], name: "index_mentions_on_status_id"
  end

  create_table "mutes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "target_account_id", null: false
    t.index ["account_id", "target_account_id"], name: "index_mutes_on_account_id_and_target_account_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "activity_id"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.bigint "from_account_id"
    t.index ["account_id", "activity_id", "activity_type"], name: "account_activity", unique: true
    t.index ["activity_id", "activity_type"], name: "index_notifications_on_activity_id_and_activity_type"
    t.index ["id", "account_id", "activity_type"], name: "index_notifications_on_id_and_account_id_and_activity_type", order: { id: :desc }
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.bigint "application_id", null: false
    t.bigint "resource_owner_id", null: false
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.bigint "application_id"
    t.bigint "resource_owner_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "superapp", default: false, null: false
    t.string "website"
    t.string "owner_type"
    t.bigint "owner_id"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "preview_cards", force: :cascade do |t|
    t.string "url", default: "", null: false
    t.string "title", default: "", null: false
    t.string "description", default: "", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "type", default: 0, null: false
    t.text "html", default: "", null: false
    t.string "author_name", default: "", null: false
    t.string "author_url", default: "", null: false
    t.string "provider_name", default: "", null: false
    t.string "provider_url", default: "", null: false
    t.integer "width", default: 0, null: false
    t.integer "height", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url"], name: "index_preview_cards_on_url", unique: true
  end

  create_table "preview_cards_statuses", id: false, force: :cascade do |t|
    t.bigint "preview_card_id", null: false
    t.bigint "status_id", null: false
    t.index ["status_id", "preview_card_id"], name: "index_preview_cards_statuses_on_status_id_and_preview_card_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "status_ids", default: [], null: false, array: true
    t.text "comment", default: "", null: false
    t.boolean "action_taken", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "action_taken_by_account_id"
    t.bigint "target_account_id", null: false
    t.index ["account_id"], name: "index_reports_on_account_id"
    t.index ["target_account_id"], name: "index_reports_on_target_account_id"
  end

  create_table "session_activations", force: :cascade do |t|
    t.string "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent", default: "", null: false
    t.inet "ip"
    t.bigint "access_token_id"
    t.bigint "user_id", null: false
    t.bigint "web_push_subscription_id"
    t.index ["session_id"], name: "index_session_activations_on_session_id", unique: true
    t.index ["user_id"], name: "index_session_activations_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "thing_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "thing_id"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "site_uploads", force: :cascade do |t|
    t.string "var", default: "", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.json "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["var"], name: "index_site_uploads_on_var", unique: true
  end

  create_table "status_pins", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "status_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["account_id", "status_id"], name: "index_status_pins_on_account_id_and_status_id", unique: true
  end

  create_table "statuses", id: :bigint, default: -> { "timestamp_id('statuses'::text)" }, force: :cascade do |t|
    t.string "uri"
    t.text "text", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "in_reply_to_id"
    t.bigint "reblog_of_id"
    t.string "url"
    t.boolean "sensitive", default: false, null: false
    t.integer "visibility", default: 0, null: false
    t.text "spoiler_text", default: "", null: false
    t.boolean "reply", default: false, null: false
    t.integer "favourites_count", default: 0, null: false
    t.integer "reblogs_count", default: 0, null: false
    t.string "language"
    t.bigint "conversation_id"
    t.boolean "local"
    t.bigint "account_id", null: false
    t.bigint "application_id"
    t.bigint "in_reply_to_account_id"
    t.index ["account_id", "id"], name: "index_statuses_on_account_id_id"
    t.index ["conversation_id"], name: "index_statuses_on_conversation_id"
    t.index ["in_reply_to_id"], name: "index_statuses_on_in_reply_to_id"
    t.index ["reblog_of_id"], name: "index_statuses_on_reblog_of_id"
    t.index ["uri"], name: "index_statuses_on_uri", unique: true
  end

  create_table "statuses_tags", id: false, force: :cascade do |t|
    t.bigint "status_id", null: false
    t.bigint "tag_id", null: false
    t.index ["status_id"], name: "index_statuses_tags_on_status_id"
    t.index ["tag_id", "status_id"], name: "index_statuses_tags_on_tag_id_and_status_id", unique: true
  end

  create_table "stream_entries", force: :cascade do |t|
    t.bigint "activity_id"
    t.string "activity_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_stream_entries_on_account_id"
    t.index ["activity_id", "activity_type"], name: "index_stream_entries_on_activity_id_and_activity_type"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "callback_url", default: "", null: false
    t.string "secret"
    t.datetime "expires_at"
    t.boolean "confirmed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_successful_delivery_at"
    t.string "domain"
    t.bigint "account_id", null: false
    t.index ["account_id", "callback_url"], name: "index_subscriptions_on_account_id_and_callback_url", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) text_pattern_ops", name: "hashtag_search_index"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "admin", default: false, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "locale"
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login", default: false, null: false
    t.datetime "last_emailed_at"
    t.string "otp_backup_codes", array: true
    t.string "filtered_languages", default: [], null: false, array: true
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["filtered_languages"], name: "index_users_on_filtered_languages", using: :gin
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "web_push_subscriptions", force: :cascade do |t|
    t.string "endpoint", null: false
    t.string "key_p256dh", null: false
    t.string "key_auth", null: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "web_settings", force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_web_settings_on_user_id", unique: true
  end

  add_foreign_key "account_domain_blocks", "accounts", name: "fk_206c6029bd", on_delete: :cascade
  add_foreign_key "account_moderation_notes", "accounts"
  add_foreign_key "account_moderation_notes", "accounts", column: "target_account_id"
  add_foreign_key "blocks", "accounts", column: "target_account_id", name: "fk_9571bfabc1", on_delete: :cascade
  add_foreign_key "blocks", "accounts", name: "fk_4269e03e65", on_delete: :cascade
  add_foreign_key "conversation_mutes", "accounts", name: "fk_225b4212bb", on_delete: :cascade
  add_foreign_key "conversation_mutes", "conversations", on_delete: :cascade
  add_foreign_key "favourites", "accounts", name: "fk_5eb6c2b873", on_delete: :cascade
  add_foreign_key "favourites", "statuses", name: "fk_b0e856845e", on_delete: :cascade
  add_foreign_key "follow_requests", "accounts", column: "target_account_id", name: "fk_9291ec025d", on_delete: :cascade
  add_foreign_key "follow_requests", "accounts", name: "fk_76d644b0e7", on_delete: :cascade
  add_foreign_key "follows", "accounts", column: "target_account_id", name: "fk_745ca29eac", on_delete: :cascade
  add_foreign_key "follows", "accounts", name: "fk_32ed1b5560", on_delete: :cascade
  add_foreign_key "imports", "accounts", name: "fk_6db1b6e408", on_delete: :cascade
  add_foreign_key "media_attachments", "accounts", name: "fk_96dd81e81b", on_delete: :nullify
  add_foreign_key "media_attachments", "statuses", on_delete: :nullify
  add_foreign_key "mentions", "accounts", name: "fk_970d43f9d1", on_delete: :cascade
  add_foreign_key "mentions", "statuses", on_delete: :cascade
  add_foreign_key "mutes", "accounts", column: "target_account_id", name: "fk_eecff219ea", on_delete: :cascade
  add_foreign_key "mutes", "accounts", name: "fk_b8d8daf315", on_delete: :cascade
  add_foreign_key "notifications", "accounts", column: "from_account_id", name: "fk_fbd6b0bf9e", on_delete: :cascade
  add_foreign_key "notifications", "accounts", name: "fk_c141c8ee55", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id", name: "fk_34d54b0a33", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id", name: "fk_63b044929b", on_delete: :cascade
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id", name: "fk_f5fc4c1ee3", on_delete: :cascade
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id", name: "fk_e84df68546", on_delete: :cascade
  add_foreign_key "oauth_applications", "users", column: "owner_id", name: "fk_b0988c7c0a", on_delete: :cascade
  add_foreign_key "reports", "accounts", column: "action_taken_by_account_id", name: "fk_bca45b75fd", on_delete: :nullify
  add_foreign_key "reports", "accounts", column: "target_account_id", name: "fk_eb37af34f0", on_delete: :cascade
  add_foreign_key "reports", "accounts", name: "fk_4b81f7522c", on_delete: :cascade
  add_foreign_key "session_activations", "oauth_access_tokens", column: "access_token_id", name: "fk_957e5bda89", on_delete: :cascade
  add_foreign_key "session_activations", "users", name: "fk_e5fda67334", on_delete: :cascade
  add_foreign_key "status_pins", "accounts", name: "fk_d4cb435b62", on_delete: :cascade
  add_foreign_key "status_pins", "statuses", on_delete: :cascade
  add_foreign_key "statuses", "accounts", column: "in_reply_to_account_id", name: "fk_c7fa917661", on_delete: :nullify
  add_foreign_key "statuses", "accounts", name: "fk_9bda1543f7", on_delete: :cascade
  add_foreign_key "statuses", "statuses", column: "in_reply_to_id", on_delete: :nullify
  add_foreign_key "statuses", "statuses", column: "reblog_of_id", on_delete: :cascade
  add_foreign_key "statuses_tags", "statuses", on_delete: :cascade
  add_foreign_key "statuses_tags", "tags", name: "fk_3081861e21", on_delete: :cascade
  add_foreign_key "stream_entries", "accounts", name: "fk_5659b17554", on_delete: :cascade
  add_foreign_key "subscriptions", "accounts", name: "fk_9847d1cbb5", on_delete: :cascade
  add_foreign_key "users", "accounts", name: "fk_50500f500d", on_delete: :cascade
  add_foreign_key "web_settings", "users", name: "fk_11910667b2", on_delete: :cascade
end
