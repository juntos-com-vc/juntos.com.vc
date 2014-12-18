# encoding: utf-8

class UserUploader < ImageUploader

  version :thumb_avatar
  version :larger_thumb_avatar

  version :thumb_avatar do
    process resize_to_fill: [119,121]
    process convert: :jpg
  end

  version :larger_thumb_avatar do
    process resize_to_fill: [256, 256]
    process convert: :jpg
  end

end
