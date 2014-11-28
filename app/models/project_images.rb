class ProjectImages < ActiveRecord::Base
  belongs_to :project

  validates :image, presence: true
end
