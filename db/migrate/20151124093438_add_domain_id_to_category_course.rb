class AddDomainIdToCategoryCourse < ActiveRecord::Migration
  def change
    add_column :category_courses, :domain_id, :integer
  end
end
