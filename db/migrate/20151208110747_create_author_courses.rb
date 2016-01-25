class CreateAuthorCourses < ActiveRecord::Migration
  def up
    create_table :author_courses, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :user_id, default: 0
      t.integer :course_id, default: 0
      t.timestamps null: false
    end

    course_institutions = CourseInstitution.all
    course_institutions.each do |ci|
      ac = AuthorCourse.new
      ac.user_id = ci.user_id
      ac.course_id = ci.course_id
      ac.save
    end
  end

  def down
    drop_table :author_courses
  end
end
