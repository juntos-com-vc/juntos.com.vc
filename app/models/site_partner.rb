class SitePartner < ActiveRecord::Base

  validates_presence_of :name, :url, :logo
  mount_uploader :logo, SitePartnerUploader

  scope :featured, -> { where(featured: true).order('random()').limit(4) }
  scope :regular, -> { where(featured: false).order('random()').limit(5) }

end
