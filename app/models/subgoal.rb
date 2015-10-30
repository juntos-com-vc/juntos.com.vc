class Subgoal < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :value, presence: true
end
