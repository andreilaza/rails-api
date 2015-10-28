class CreateAuthorMetadata < ActiveRecord::Migration
  def change
    create_table :author_metadata do |t|
      t.integer :user_id, default: 0
      t.string :facebook, default: ""
      t.string :twitter, default: ""
      t.string :linkedin, default: ""
      t.text :biography
      t.string :position, default: ""
      t.timestamps null: false
    end
  end
end
