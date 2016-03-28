class AddProcessingImagesFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :image_processing, :boolean
    add_column :projects, :cover_image_processing, :boolean

    add_column :projects, :original_uploaded_image, :string
    add_column :projects, :original_uploaded_cover_image, :string
  end
end
