class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title, default: ""
      t.string :description, default: ""
      t.string :image, default: ""
      t.integer :course_id

      t.timestamps null: false
    end

    add_index :chapters, :title
    add_index :chapters, :course_id
  end
end
