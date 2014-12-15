class AddFieldsToSitePartners < ActiveRecord::Migration
  def change
    add_column :site_partners, :phone, :string
    add_column :site_partners, :bio, :text
    add_column :site_partners, :address, :text
  end
end
