# encoding: utf-8

class ProjectPartnersUploader < ImageUploader

  version :thumb

  def store_dir
    "uploads/project/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fit: [250,75]
    process convert: :jpg
  end

end
