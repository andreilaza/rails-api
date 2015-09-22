class AddCompletedToStudentsCourse < ActiveRecord::Migration
  def change
    add_column :students_courses, :completed, :boolean, default: false
  end
end
