class CreateHomeBanners < ActiveRecord::Migration
  def change
    create_table :home_banners do |t|
      t.string :image

      t.timestamps
    end
  end
end
