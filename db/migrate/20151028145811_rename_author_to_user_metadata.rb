class RenameAuthorToUserMetadata < ActiveRecord::Migration
  def change
    rename_table :author_metadata, :user_metadata
  end
end
