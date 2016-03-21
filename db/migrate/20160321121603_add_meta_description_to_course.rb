class AddMetaDescriptionToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :meta_description, :text
  end
end
