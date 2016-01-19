class CreateSectionSettings < ActiveRecord::Migration
  def change
    create_table :section_settings do |t|
      t.integer :section_id, default: 0
      t.string :key, default: ""
      t.string :value, default: ""
      t.timestamps null: false
    end
  end
end
