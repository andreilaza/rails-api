class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title, default: ""
      t.string :description, default: ""
      t.integer :chapter_id

      t.timestamps null: false
    end

    add_index :sections, :title
    add_index :sections, :chapter_id
  end
end
