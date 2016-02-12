class ChangeHashToSlugString < ActiveRecord::Migration
  def change
    rename_column :courses, :hash, :slug_string
    rename_column :chapters, :hash, :slug_string
    rename_column :sections, :hash, :slug_string
    rename_column :domains, :hash, :slug_string
    rename_column :categories, :hash, :slug_string
    rename_column :institutions, :hash, :slug_string
  end
end
