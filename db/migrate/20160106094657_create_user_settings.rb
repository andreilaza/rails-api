class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :user_id, default: 0
      t.string :key, default: ""
      t.string :value, default: ""
      t.timestamps null: false
    end
  end
end
