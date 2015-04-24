class AddNumericOrderToHomeBanners < ActiveRecord::Migration
  def change
    add_column :home_banners, :numeric_order, :integer, default: 0
  end
end
