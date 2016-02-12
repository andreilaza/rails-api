class CreateDomains < ActiveRecord::Migration
  def change    
    create_table :domains, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.text :description
      t.timestamps null: false
    end
  end
end
