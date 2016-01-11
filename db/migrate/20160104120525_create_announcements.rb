class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :user_id, default: 0
      t.text :announcement      
      t.timestamps null: false
    end
  end
end
