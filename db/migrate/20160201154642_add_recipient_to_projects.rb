class AddRecipientToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :recipient, :string
  end
end
