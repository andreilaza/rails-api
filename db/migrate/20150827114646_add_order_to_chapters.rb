class AddOrderToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :order, :integer
  end
end
