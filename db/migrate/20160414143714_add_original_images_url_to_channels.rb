class AddOriginalImagesUrlToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :original_image_url, :string
    add_column :channels, :image_processing, :boolean, default: false

    add_column :channels, :email_header_image, :string
    add_column :channels, :original_email_header_image_url, :string
    add_column :channels, :email_header_image_processing, :boolean,
                default: false
  end
end
