class AddMoipIdColumnToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :moip_code, :string
  end
end
