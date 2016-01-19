class AddTryToStudentsQuestions < ActiveRecord::Migration
  def change
    add_column :students_questions, :try, :integer, default: 0
  end
end
