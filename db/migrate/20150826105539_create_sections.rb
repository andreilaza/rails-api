class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.string :description
      t.integer :chapter_id

      t.timestamps null: false
    end
  end
end
