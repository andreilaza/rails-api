class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title, default: ""
      t.string :description, default: ""
      t.string :image, default: ""
      t.boolean :published, default: false

      t.timestamps
    end

    add_index :courses, :title
  end
end
