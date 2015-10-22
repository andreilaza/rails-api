class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.string :description, default: ""
      t.integer :chapter_id

      t.timestamps null: false
    end

    add_index :sections, :title
    add_index :sections, :chapter_id
  end
end
