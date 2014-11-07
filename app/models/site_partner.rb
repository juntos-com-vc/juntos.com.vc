class SitePartner < ActiveRecord::Base

  validates_presence_of :name, :url, :logo
  mount_uploader :logo, ChannelPartnerUploader

end
