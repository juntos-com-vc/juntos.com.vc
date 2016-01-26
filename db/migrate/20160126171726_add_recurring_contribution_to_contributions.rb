class AddRecurringContributionToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :recurring_contribution, :integer, {
      null: true, references: :recurring_contributions}
  end
end
