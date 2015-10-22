class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.integer :question_id
      t.integer :correct, default: 0
      t.integer :order, default: 0

      t.timestamps null: false
    end

    add_index :answers, :question_id
  end
end
