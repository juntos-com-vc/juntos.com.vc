class Summary < ActiveRecord::Base
  belongs_to :project

  scope :site, -> { where(project_id: nil) }
end
