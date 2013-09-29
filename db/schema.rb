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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130922171804) do

  create_table "brand_subcategory_masters", :force => true do |t|
    t.integer  "category_id"
    t.string   "sub_category"
    t.string   "comment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "cities", :id => false, :force => true do |t|
    t.string "city",       :limit => 50, :null => false
    t.string "state_code", :limit => 2,  :null => false
  end

  add_index "cities", ["state_code"], :name => "idx_state_code"

  create_table "contact_us", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "company_name"
    t.string   "location"
    t.string   "phone_no"
    t.text     "message"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "jobcategorymasters", :force => true do |t|
    t.string   "category"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.string   "job_title"
    t.text     "job_description"
    t.integer  "job_category"
    t.integer  "job_sub_category"
    t.string   "job_skill"
    t.integer  "job_price_type"
    t.string   "job_price_hour_range"
    t.string   "job_price_fixed_type"
    t.string   "job_valid_for"
    t.date     "job_start_date"
    t.integer  "job_user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "crowd_size"
    t.time     "time"
    t.string   "proof_selector"
    t.string   "city"
    t.string   "state"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ribbits", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :primary_key => "state_code", :force => true do |t|
    t.string "state", :limit => 22, :null => false
  end

  create_table "user_job_proposals", :force => true do |t|
    t.text     "proposal_details"
    t.string   "proposal_cost"
    t.string   "my_earning"
    t.integer  "is_submit_later"
    t.integer  "is_place_mine_at_the_top"
    t.date     "estimate_delivery_date"
    t.integer  "job_id"
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "user_messages", :force => true do |t|
    t.integer  "from_user"
    t.integer  "to_user"
    t.string   "message_title"
    t.text     "message_body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_no"
    t.string   "company_name"
    t.integer  "is_approved",            :default => 0
    t.integer  "user_type"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.datetime "dob"
    t.string   "image"
    t.text     "description"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "facebook"
    t.integer  "is_processed",           :default => 0
    t.string   "website"
    t.integer  "interest"
    t.string   "press"
    t.string   "website_title"
    t.string   "press_title"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
