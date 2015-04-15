class AddLinkToHomeBanners < ActiveRecord::Migration
  def change
    add_column :home_banners, :link, :string
  end
end
