class ProjectPartner < ActiveRecord::Base
  belongs_to :project
  mount_uploader :image, ProjectPartnersUploader

  validates_presence_of :original_image_url, on: :create

  before_save :check_url
  after_commit :process_async, on: :create

  private

  def check_url
    self.image_processing = true if new_record? && original_image_url
  end

  def process_async
    ProjectPartnerProcessWorker.perform_async(self.id, original_image_url)
  end
end
