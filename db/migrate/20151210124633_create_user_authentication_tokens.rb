class CreateUserAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :user_authentication_tokens do |t|
      t.integer :user_id, default: 0
      t.string :token, default: ""
      t.datetime :expires_at
      t.timestamps null: false
    end
  end
end
