class ChangeAssetToSectionId < ActiveRecord::Migration
  def change
    rename_column :video_moments, :asset_id, :section_id
  end
end
