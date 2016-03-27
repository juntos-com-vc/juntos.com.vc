class ProjectImage < ActiveRecord::Base
  belongs_to :project
  mount_uploader :image, ProjectUploader

  validates :original_image_url, presence: true

  before_save :check_url

  private

  def check_url
    self.image_processing = (new_record? || original_image_url?)
  end
end
