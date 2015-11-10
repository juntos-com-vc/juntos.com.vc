class Subgoal < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :value, presence: true

  def percentual_from_total(v = value)
    return v > project.goal ? 100 : v / self.project.goal * 100
  end
end
