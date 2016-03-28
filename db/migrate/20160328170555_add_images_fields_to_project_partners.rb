class AddImagesFieldsToProjectPartners < ActiveRecord::Migration
  def change
    add_column :project_partners, :image_processing, :boolean
    add_column :project_partners, :original_image_url, :string
  end
end
