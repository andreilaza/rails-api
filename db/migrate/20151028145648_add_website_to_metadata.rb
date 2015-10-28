class AddWebsiteToMetadata < ActiveRecord::Migration
  def change
    add_column :author_metadata, :website, :string, default: ""
  end
end
