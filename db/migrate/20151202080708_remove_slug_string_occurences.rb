class RemoveSlugStringOccurences < ActiveRecord::Migration
  def change
    remove_column :courses, :slug_string
    remove_column :chapters, :slug_string
    remove_column :sections, :slug_string
    remove_column :institutions, :slug_string
    remove_column :categories, :slug_string
    remove_column :domains, :slug_string

    remove_column :courses, :occurences
    remove_column :chapters, :occurences
    remove_column :sections, :occurences
    remove_column :institutions, :occurences
    remove_column :categories, :occurences
    remove_column :domains, :occurences
  end
end
