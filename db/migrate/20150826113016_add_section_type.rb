class AddSectionType < ActiveRecord::Migration
  def change
    add_column :sections, :type, :integer, default: 1
  end
end
