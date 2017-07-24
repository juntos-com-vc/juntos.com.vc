class AddRecipientIdToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :pagarme_recipient, :string, :null => true
  end
end
