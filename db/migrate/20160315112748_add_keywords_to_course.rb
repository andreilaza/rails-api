class AddKeywordsToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :keywords, :string, default: ""
  end
end
