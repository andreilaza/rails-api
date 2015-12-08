class RemoveRemaining < ActiveRecord::Migration
  def change
    remove_column :students_questions, :remaining
  end
end
