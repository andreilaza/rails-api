class CreateInstitutionUsers < ActiveRecord::Migration
  def change
    create_table :institution_users do |t|
      t.integer :institution_id 
      t.integer :user_id 
      t.timestamps null: false
    end

    add_index :institution_users, :institution_id
    add_index :institution_users, :user_id
  end
end
