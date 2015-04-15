class HomeBanner < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
