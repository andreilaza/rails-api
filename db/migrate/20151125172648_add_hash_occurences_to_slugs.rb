class AddHashOccurencesToSlugs < ActiveRecord::Migration
  def change
    add_column :courses, :hash, :string, default: ""
    add_column :chapters, :hash, :string, default: ""
    add_column :sections, :hash, :string, default: ""
    add_column :institutions, :hash, :string, default: ""
    add_column :categories, :hash, :string, default: ""
    add_column :domains, :hash, :string, default: ""

    add_column :courses, :occurences, :integer, default: 0
    add_column :chapters, :occurences, :integer, default: 0
    add_column :sections, :occurences, :integer, default: 0
    add_column :institutions, :occurences, :integer, default: 0
    add_column :categories, :occurences, :integer, default: 0
    add_column :domains, :occurences, :integer, default: 0
  end
end
