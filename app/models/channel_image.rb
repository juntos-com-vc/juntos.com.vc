class ChannelImage < ActiveRecord::Base
  belongs_to :channel
  mount_uploader :image, ProfileUploader
  validates :image, presence: true
  scope :ordered, -> { order('id desc') }
end
