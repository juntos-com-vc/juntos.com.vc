class AddAccessTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_type, :integer, null: false, default: 0
  end
end
