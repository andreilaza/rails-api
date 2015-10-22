class CreateStudentsSections < ActiveRecord::Migration
  def change
    create_table :students_sections, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :course_id
      t.integer :user_id
      t.integer :chapter_id
      t.integer :section_id
      t.boolean :completed, default: false
      t.timestamps null: false
    end

    add_index :students_sections, :course_id
    add_index :students_sections, :user_id
    add_index :students_sections, :chapter_id
    add_index :students_sections, :section_id
  end
end
