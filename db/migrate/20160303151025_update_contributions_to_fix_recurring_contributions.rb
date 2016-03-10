class UpdateContributionsToFixRecurringContributions < ActiveRecord::Migration
  def change
    add_column :recurring_contributions, :cancelled_at, :timestamp
    rename_column :contributions, :recurring_contribution, :recurring_contribution_id
  end
end
