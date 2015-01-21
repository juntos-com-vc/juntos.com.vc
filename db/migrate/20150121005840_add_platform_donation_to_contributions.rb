class AddPlatformDonationToContributions < ActiveRecord::Migration
  def up
    add_column :contributions, :project_value, :decimal
    add_column :contributions, :platform_value, :decimal
  end

  def down
    remove_column :contributions, :project_value, :decimal
    remove_column :contributions, :platform_value, :decimal
  end
end
