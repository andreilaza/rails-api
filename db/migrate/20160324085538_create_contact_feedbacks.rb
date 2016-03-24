class CreateContactFeedbacks < ActiveRecord::Migration
  def change
    create_table :contact_feedbacks do |t|
      t.string :name, default: ""
      t.string :email, default: ""
      t.text :message
      t.timestamps null: false
    end
  end
end
