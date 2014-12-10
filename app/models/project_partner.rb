class ProjectPartner < ActiveRecord::Base
  belongs_to :project
  mount_uploader :image, ProjectPartnersUploader

  validates :image, presence: true
end
