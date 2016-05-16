class AddDependencyToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :dependency_id, :integer, default: 0
  end
end
