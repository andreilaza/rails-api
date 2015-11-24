class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.text :description
      t.integer :domain_id, default: 0
      t.timestamps null: false
    end
  end
end
