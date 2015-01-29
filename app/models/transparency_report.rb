class TransparencyReport < ActiveRecord::Base

  validates_presence_of :attachment, :previous_attachment
  mount_uploader :attachment, DocumentUploader
  mount_uploader :previous_attachment, DocumentUploader

end
