# encoding: utf-8

class ProfileUploader < ImageUploader

  version :curator_thumb do
    process resize_to_limit: [1200,630]
    process convert: :jpg
  end

  version :slick do
    process resize_to_fill: [1900,360]
    process convert: :jpg
  end

  version :header do
    process resize_to_fill: [176, 38]
    process convert: :jpg
  end

end
