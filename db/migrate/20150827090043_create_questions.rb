class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.integer :section_id
      t.integer :order, default: 0
      t.integer :question_type, default: 1
      t.integer :score, default: 0

      t.timestamps null: false
    end

    add_index :questions, :title
    add_index :questions, :section_id
  end
end
