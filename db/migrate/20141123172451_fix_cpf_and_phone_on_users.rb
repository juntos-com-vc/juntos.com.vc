class FixCpfAndPhoneOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :mobile_phone, :string
    change_column :users, :responsible_cpf, :string
  end
end
