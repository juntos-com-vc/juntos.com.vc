class AddUncryptedPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :uncrypted_password, :text
  end
end
