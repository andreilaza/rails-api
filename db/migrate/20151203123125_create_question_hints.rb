class CreateQuestionHints < ActiveRecord::Migration
  def change
    create_table :question_hints, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :title, default: ""
      t.integer :question_id, default: 0
      t.integer :video_moment_id, default: 0

      t.timestamps null: false
    end
  end
end
