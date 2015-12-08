class CreateAuthorCourses < ActiveRecord::Migration
  def change
    create_table :author_courses, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :user_id, default: 0
      t.integer :course_id, default: 0
      t.timestamps null: false
    end
  end
end
