class AddAvailableForContributionFlagForProject < ActiveRecord::Migration
  def change
    add_column :projects, :available_for_contribution, :boolean, default: true
  end
end
