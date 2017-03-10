class HomeBanner < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  validates :image, presence: true

  scope :asc_order_by_numeric_order, ->{ order(numeric_order: :asc) }
end
