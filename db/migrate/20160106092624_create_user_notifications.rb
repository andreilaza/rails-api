class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :user_id, default: 0
      t.integer :notification_id, default: 0
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
