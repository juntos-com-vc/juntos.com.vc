class AddPartnerNameAndParterMessageToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :partner_name, :string
    add_column :projects, :partner_message, :string
  end
end
