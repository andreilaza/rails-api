class RemoveImageFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :image
  end
end
