class AddColorsToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :main_color, :string
    add_column :channels, :secondary_color, :string
  end
end
