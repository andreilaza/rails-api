class ChangeScoreToFloat < ActiveRecord::Migration
  def change
    change_column :students_questions, :score, :float, default: 0
  end
end
