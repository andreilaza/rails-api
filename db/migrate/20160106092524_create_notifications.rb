class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.references :entity, polymorphic: true, index: true
      t.integer :notification_type, default:0
      t.text :message
      t.timestamps null: false
    end
  end
end
