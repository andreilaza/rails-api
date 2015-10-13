class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :title, default: ""
      t.string :image, default: ""
      t.string :description, default: ""

      t.timestamps
    end
    add_index :institutions, :title
  end
end
