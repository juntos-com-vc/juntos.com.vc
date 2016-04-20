class AddStaffsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :staffs, :integer, array: true, default: []
  end
end
