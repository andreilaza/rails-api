class AddTypeToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :invitation_type, :integer, default: 1
  end
end
