class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.string :image, default: ""
      t.string :description, default: ""

      t.timestamps
    end
    add_index :institutions, :title
  end
end
