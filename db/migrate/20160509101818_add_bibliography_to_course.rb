class AddBibliographyToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :bibliography, :text
  end
end
