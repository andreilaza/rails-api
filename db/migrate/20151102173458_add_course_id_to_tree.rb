class AddCourseIdToTree < ActiveRecord::Migration
  def change
    add_column :sections, :course_id, :integer, default: 0
    add_column :questions, :course_id, :integer, default: 0
    add_column :answers, :course_id, :integer, default: 0
  end
end
