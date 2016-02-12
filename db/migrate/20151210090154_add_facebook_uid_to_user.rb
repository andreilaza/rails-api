class AddFacebookUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string, default: ""
  end
end