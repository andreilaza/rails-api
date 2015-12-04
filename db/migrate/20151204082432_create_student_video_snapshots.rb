class CreateStudentVideoSnapshots < ActiveRecord::Migration
  def change
    create_table :student_video_snapshots, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.float :moment
      t.integer :user_id
      t.integer :asset_id
      t.timestamps null: false
    end
  end
end
