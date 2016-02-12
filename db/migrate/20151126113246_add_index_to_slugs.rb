class AddIndexToSlugs < ActiveRecord::Migration
  def change
    add_index :courses, :slug
    add_index :chapters, :slug
    add_index :sections, :slug
    add_index :domains, :slug
    add_index :categories, :slug
    add_index :institutions, :slug
  end
end
