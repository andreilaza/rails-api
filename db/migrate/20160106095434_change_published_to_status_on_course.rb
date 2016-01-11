class ChangePublishedToStatusOnCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :published
    add_column :courses, :status, :integer, default: 0
  end
end
