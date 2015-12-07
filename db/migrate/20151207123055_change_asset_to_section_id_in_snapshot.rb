class ChangeAssetToSectionIdInSnapshot < ActiveRecord::Migration
  def change
    rename_column :student_video_snapshots, :asset_id, :section_id
  end
end
