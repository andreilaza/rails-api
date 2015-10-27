class AddUrlToInstitutions < ActiveRecord::Migration
  def change
    add_column :sections, :url, :string, default: ""
  end
end
