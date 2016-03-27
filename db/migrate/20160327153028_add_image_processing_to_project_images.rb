class AddImageProcessingToProjectImages < ActiveRecord::Migration
  def change
    add_column :project_images, :image_processing, :boolean
  end
end
