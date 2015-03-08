class AddCoverImageToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :uploaded_cover_image, :string
  end
end
