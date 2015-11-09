class ChangeDescriptionToText < ActiveRecord::Migration
  def change
    change_column :courses, :description, :text, :limit => 16777215, :default => nil, :null => true
  end
end
