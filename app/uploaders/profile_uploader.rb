# encoding: utf-8

class ProfileUploader < ImageUploader

  version :curator_thumb do
    process resize_to_limit: [1200, 630]
  end

  version :slick do
    process resize_to_fill: [1900, 360]
  end

  version :header do
    process resize_to_fill: [176, 38]
  end

  version :email_header do
    process resize_to_fill: [600, 130]
  end

end
