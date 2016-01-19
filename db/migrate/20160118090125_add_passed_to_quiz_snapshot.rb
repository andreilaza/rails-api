class AddPassedToQuizSnapshot < ActiveRecord::Migration
  def change
    add_column :quiz_snapshots, :passed, :boolean, default: false
  end
end
