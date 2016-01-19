class CreateQuizSnapshots < ActiveRecord::Migration
  def change
    create_table :quiz_snapshots do |t|
      t.integer :user_id, default:0
      t.integer :section_id, default: 0
      t.float :score, default: 0
      t.timestamps null: false
    end
  end
end
