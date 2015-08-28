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

ActiveRecord::Schema.define(version: 20150828073539) do

  create_table "answers", force: :cascade do |t|
    t.string   "title",       default: ""
    t.integer  "question_id"
    t.boolean  "correct",     default: false
    t.integer  "order",       default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "chapters", force: :cascade do |t|
    t.string   "title",       default: ""
    t.string   "description", default: ""
    t.string   "image",       default: ""
    t.integer  "course_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "order"
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id"
  add_index "chapters", ["title"], name: "index_chapters_on_title"

  create_table "course_institutions", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "course_institutions", ["course_id"], name: "index_course_institutions_on_course_id"
  add_index "course_institutions", ["institution_id"], name: "index_course_institutions_on_institution_id"

  create_table "courses", force: :cascade do |t|
    t.string   "title",       default: ""
    t.string   "description", default: ""
    t.string   "image",       default: ""
    t.boolean  "published",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["title"], name: "index_courses_on_title"

  create_table "institution_users", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "institution_users", ["institution_id"], name: "index_institution_users_on_institution_id"
  add_index "institution_users", ["user_id"], name: "index_institution_users_on_user_id"

  create_table "institutions", force: :cascade do |t|
    t.string   "title",       default: ""
    t.string   "image",       default: ""
    t.string   "description", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutions", ["title"], name: "index_institutions_on_title"

  create_table "questions", force: :cascade do |t|
    t.string   "title",         default: ""
    t.integer  "section_id"
    t.integer  "order",         default: 0
    t.integer  "question_type", default: 1
    t.integer  "score",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "questions", ["section_id"], name: "index_questions_on_section_id"
  add_index "questions", ["title"], name: "index_questions_on_title"

  create_table "sections", force: :cascade do |t|
    t.string   "title",        default: ""
    t.string   "description",  default: ""
    t.integer  "chapter_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "section_type", default: 1
    t.integer  "order"
  end

  add_index "sections", ["chapter_id"], name: "index_sections_on_chapter_id"
  add_index "sections", ["title"], name: "index_sections_on_title"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token",             default: ""
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
