class AddRecurringToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :recurring, :boolean, default: :false
  end
end
