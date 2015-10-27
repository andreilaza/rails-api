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

ActiveRecord::Schema.define(version: 20151015081703) do

  create_table "answers", force: :cascade do |t|
    t.string   "title",       limit: 255, default: ""
    t.integer  "question_id", limit: 4
    t.boolean  "correct",                 default: false
    t.integer  "order",       limit: 4,   default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "assets", force: :cascade do |t|
    t.integer  "entity_id",   limit: 4,     default: 0
    t.string   "entity_type", limit: 255,   default: ""
    t.string   "path",        limit: 255,   default: ""
    t.string   "definition",  limit: 255,   default: ""
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.text     "metadata",    limit: 65535
  end

  add_index "assets", ["entity_id"], name: "index_assets_on_entity_id", using: :btree
  add_index "assets", ["entity_type"], name: "index_assets_on_entity_type", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.string   "title",       limit: 255, default: ""
    t.string   "description", limit: 255, default: ""
    t.string   "image",       limit: 255, default: ""
    t.integer  "course_id",   limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "order",       limit: 4
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id", using: :btree
  add_index "chapters", ["title"], name: "index_chapters_on_title", using: :btree

  create_table "course_institutions", force: :cascade do |t|
    t.integer  "course_id",      limit: 4
    t.integer  "institution_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "course_institutions", ["course_id"], name: "index_course_institutions_on_course_id", using: :btree
  add_index "course_institutions", ["institution_id"], name: "index_course_institutions_on_institution_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "title",       limit: 255, default: ""
    t.string   "description", limit: 255, default: ""
    t.boolean  "published",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["title"], name: "index_courses_on_title", using: :btree

  create_table "institution_users", force: :cascade do |t|
    t.integer  "institution_id", limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "institution_users", ["institution_id"], name: "index_institution_users_on_institution_id", using: :btree
  add_index "institution_users", ["user_id"], name: "index_institution_users_on_user_id", using: :btree

  create_table "institutions", force: :cascade do |t|
    t.string   "title",       limit: 255,   default: ""
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "institutions", ["title"], name: "index_institutions_on_title", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.string   "email",      limit: 255, default: ""
    t.string   "invitation", limit: 255, default: ""
    t.integer  "sent",       limit: 4,   default: 0
    t.datetime "expires"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string   "title",         limit: 255, default: ""
    t.integer  "section_id",    limit: 4
    t.integer  "order",         limit: 4,   default: 0
    t.integer  "question_type", limit: 4,   default: 1
    t.integer  "score",         limit: 4,   default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "questions", ["section_id"], name: "index_questions_on_section_id", using: :btree
  add_index "questions", ["title"], name: "index_questions_on_title", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title",        limit: 255, default: ""
    t.string   "description",  limit: 255, default: ""
    t.integer  "chapter_id",   limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "section_type", limit: 4,   default: 1
    t.integer  "order",        limit: 4
    t.float    "duration",     limit: 24,  default: 0.0
  end

  add_index "sections", ["chapter_id"], name: "index_sections_on_chapter_id", using: :btree
  add_index "sections", ["title"], name: "index_sections_on_title", using: :btree

  create_table "students_courses", force: :cascade do |t|
    t.integer  "course_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "completed",            default: false
  end

  add_index "students_courses", ["course_id"], name: "index_students_courses_on_course_id", using: :btree
  add_index "students_courses", ["user_id"], name: "index_students_courses_on_user_id", using: :btree

  create_table "students_questions", force: :cascade do |t|
    t.integer  "course_id",   limit: 4
    t.integer  "user_id",     limit: 4
    t.integer  "section_id",  limit: 4
    t.integer  "question_id", limit: 4
    t.boolean  "completed",             default: false
    t.integer  "remaining",   limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "students_questions", ["course_id"], name: "index_students_questions_on_course_id", using: :btree
  add_index "students_questions", ["question_id"], name: "index_students_questions_on_question_id", using: :btree
  add_index "students_questions", ["section_id"], name: "index_students_questions_on_section_id", using: :btree
  add_index "students_questions", ["user_id"], name: "index_students_questions_on_user_id", using: :btree

  create_table "students_sections", force: :cascade do |t|
    t.integer  "course_id",  limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "chapter_id", limit: 4
    t.integer  "section_id", limit: 4
    t.boolean  "completed",            default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "students_sections", ["chapter_id"], name: "index_students_sections_on_chapter_id", using: :btree
  add_index "students_sections", ["course_id"], name: "index_students_sections_on_course_id", using: :btree
  add_index "students_sections", ["section_id"], name: "index_students_sections_on_section_id", using: :btree
  add_index "students_sections", ["user_id"], name: "index_students_sections_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "auth_token",             limit: 255, default: ""
    t.integer  "role",                   limit: 4,   default: 1
    t.string   "first_name",             limit: 255, default: ""
    t.string   "last_name",              limit: 255, default: ""
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "waiting_lists", force: :cascade do |t|
    t.string   "email",      limit: 255, default: ""
    t.integer  "sent",       limit: 4,   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
