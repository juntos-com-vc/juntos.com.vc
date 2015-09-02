# encoding: utf-8

class ProjectUploader < ImageUploader

  version :project_thumb
  version :project_thumb_small
  version :project_thumb_facebook
  version :project_thumb_facebook_share

  def store_dir
    "uploads/project/#{mounted_as}/#{model.id}"
  end

  version :project_header do
    process resize_to_fill: [1900, 400]
    process convert: :jpg
  end

  version :project_thumb do
    process resize_to_fill: [220,120]
    process convert: :jpg
  end

  version :project_thumb_small, from_version: :project_thumb do
    process resize_to_fill: [85,67]
    process convert: :jpg
  end

  #facebook requires a minimum thumb size
  version :project_thumb_facebook do
    process resize_to_fill: [512,400]
    process convert: :jpg
  end

  version :project_thumb_facebook_share do
    process resize_to_fill: [600,315]
    process convert: :jpg
  end

end
