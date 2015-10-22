class CreateStudentsCourses < ActiveRecord::Migration
  def change
    create_table :students_courses, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :course_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :students_courses, :course_id
    add_index :students_courses, :user_id
  end
end
