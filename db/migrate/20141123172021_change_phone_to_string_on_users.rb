class ChangePhoneToStringOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :mobile_phone, :integer
  end
end
