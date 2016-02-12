class AddScoreAndHintToSq < ActiveRecord::Migration
  def change
    add_column :students_questions, :score, :integer, default: 0
    add_column :students_questions, :hint, :boolean, default: false
  end
end
