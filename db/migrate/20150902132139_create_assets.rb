class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.integer :entity_id, default: 0
      t.string :entity_type, default: ""
      t.string :path, default: ""
      t.string :definition, default: ""

      t.timestamps null: false
    end

    add_index :assets, :entity_id
    add_index :assets, :entity_type
  end
end
