class ChangeMomentToTime < ActiveRecord::Migration
  def change
    rename_column :student_video_snapshots, :moment, :time
  end
end
