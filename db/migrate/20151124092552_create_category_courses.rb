class CreateCategoryCourses < ActiveRecord::Migration
  def change
    create_table :category_courses, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :category_id
      t.integer :course_id
      t.timestamps null: false
    end

    add_index :category_courses, :category_id
    add_index :category_courses, :course_id
  end
end
