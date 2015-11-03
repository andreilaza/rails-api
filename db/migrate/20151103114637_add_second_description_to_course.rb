class AddSecondDescriptionToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :second_description, :text
  end
end
