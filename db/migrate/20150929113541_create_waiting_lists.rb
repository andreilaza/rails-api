class CreateWaitingLists < ActiveRecord::Migration
  def change
    create_table :waiting_lists, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin' do |t|
      t.string :email, default: ""
      t.integer :sent, default: 0
      t.timestamps null: false
    end
  end
end
