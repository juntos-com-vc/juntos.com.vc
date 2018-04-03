class AddContributionIdToTicketsTable < ActiveRecord::Migration
  def change
    add_column :tickets, :contribution_id, :integer
  end
end
