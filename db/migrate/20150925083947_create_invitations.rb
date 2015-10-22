class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|

      t.string :email, default: ""
      t.string :invitation, default: ""
      t.integer :sent, default: 0
      t.datetime :expires

      t.timestamps null: false
    end    
  end
end
