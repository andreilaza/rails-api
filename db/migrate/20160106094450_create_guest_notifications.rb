class CreateGuestNotifications < ActiveRecord::Migration
  def change
    create_table :guest_notifications, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :course_id, default: 0
      t.string :email, default: ""
      t.integer :notification_id, default: nil
      t.timestamps null: false
    end
  end
end
