class Subgoal < ActiveRecord::Base
  belongs_to :project

  validates :project_id, :value, presence: true
  validate :cannot_be_higher_than_project_goal

  def percentual_from_total(v = value)
    return v > project.goal ? 100 : v / self.project.goal * 100
  end

  private

  def cannot_be_higher_than_project_goal
    value <= project.goal
  end
end
