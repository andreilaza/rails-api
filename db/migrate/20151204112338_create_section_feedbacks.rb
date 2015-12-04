class CreateSectionFeedbacks < ActiveRecord::Migration
  def change
    create_table :section_feedbacks do |t|
      t.integer :section_id
      t.integer :user_id
      t.text :feedback
      t.timestamps null: false
    end
  end
end
