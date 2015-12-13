class AddIndexToToken < ActiveRecord::Migration
  def change
    add_index :user_authentication_tokens, :token
  end
end
