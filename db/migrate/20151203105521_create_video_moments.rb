class CreateVideoMoments < ActiveRecord::Migration
  def change
    create_table :video_moments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :asset_id
      t.float :time
      t.string :title
      t.timestamps null: false
    end
  end
end