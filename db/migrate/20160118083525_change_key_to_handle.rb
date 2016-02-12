class ChangeKeyToHandle < ActiveRecord::Migration
  def change
    rename_column :section_settings, :key, :handle
  end
end
