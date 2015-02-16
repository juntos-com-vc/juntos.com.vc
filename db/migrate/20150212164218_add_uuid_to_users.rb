class AddUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :text
  end
end
