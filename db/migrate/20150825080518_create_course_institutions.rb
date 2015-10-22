class CreateCourseInstitutions < ActiveRecord::Migration
  def change
    create_table :course_institutions, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :course_id
      t.integer :institution_id
      t.timestamps null: false
    end

    add_index :course_institutions, :course_id
    add_index :course_institutions, :institution_id
  end
end
