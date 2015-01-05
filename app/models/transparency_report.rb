class TransparencyReport < ActiveRecord::Base

  validates_presence_of :attachment
  mount_uploader :attachment, DocumentUploader

end
