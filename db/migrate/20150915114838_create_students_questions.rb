class CreateStudentsQuestions < ActiveRecord::Migration
  def change
    create_table :students_questions, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :course_id
      t.integer :user_id
      t.integer :section_id
      t.integer :question_id
      t.boolean :completed, default: false
      t.integer :remaining
      t.timestamps null: false
    end

    add_index :students_questions, :course_id
    add_index :students_questions, :user_id
    add_index :students_questions, :section_id
    add_index :students_questions, :question_id
  end
end
