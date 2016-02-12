class AddSlugsToMultipleTables < ActiveRecord::Migration
  def change
    add_column :courses, :slug, :string, default: ""
    add_column :chapters, :slug, :string, default: ""
    add_column :sections, :slug, :string, default: ""
    add_column :institutions, :slug, :string, default: ""
    add_column :categories, :slug, :string, default: ""
    add_column :domains, :slug, :string, default: ""
  end
end
