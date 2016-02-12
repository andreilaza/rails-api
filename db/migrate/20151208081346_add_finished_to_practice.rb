class AddFinishedToPractice < ActiveRecord::Migration
  def change
    add_column :students_courses, :finished, :boolean, default: false
    add_column :students_sections, :finished, :boolean, default: false
    add_column :students_questions, :finished, :boolean, default: false
  end
end
