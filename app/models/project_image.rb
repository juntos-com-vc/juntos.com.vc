class ProjectImage < ActiveRecord::Base
  belongs_to :project
  mount_uploader :image, ProjectUploader

  validates :image, presence: true
end
