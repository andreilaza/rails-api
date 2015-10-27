class AddUrlToInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :url, :string, default: ""
  end
end
