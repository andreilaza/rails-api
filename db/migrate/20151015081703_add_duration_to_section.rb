class AddDurationToSection < ActiveRecord::Migration
  def change
    add_column :sections, :duration, :float, default: 0
  end
end
