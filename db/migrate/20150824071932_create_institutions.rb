class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""      
      t.text :description

      t.timestamps
    end
    add_index :institutions, :title
  end
end
