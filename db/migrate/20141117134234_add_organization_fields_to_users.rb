class AddOrganizationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :responsible_name, :string
    add_column :users, :gender, :integer
    add_column :users, :mobile_phone, :integer
    add_column :users, :responsible_cpf, :integer
  end
end
