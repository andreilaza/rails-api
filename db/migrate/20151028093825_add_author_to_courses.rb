class AddAuthorToCourses < ActiveRecord::Migration
  def change
    add_column :course_institutions, :user_id, :integer, default: 0
  end
end
