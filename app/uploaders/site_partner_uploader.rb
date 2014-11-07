# encoding: utf-8

class SitePartnerUploader < ImageUploader

  version :featured do
    process resize_to_fill: [180, 60]
  end


  version :regular do
    process resize_to_fill: [150, 50]
  end

end
