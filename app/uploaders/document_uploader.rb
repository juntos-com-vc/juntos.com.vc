# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  def self.choose_storage
    Rails.env.production? ? :fog : :file
  end

  storage choose_storage

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

end
