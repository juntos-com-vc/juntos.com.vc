# encoding: utf-8

class CategoryImageUploader < ImageUploader
  process :resize_to_fit => [54, 54]
end
