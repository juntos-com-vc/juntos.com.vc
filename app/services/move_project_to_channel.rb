class MoveProjectToChannel
  def initialize(project, channel)
    @project = project
    @channel = channel
  end

  def self.perform(project, channel)
    new(project, channel).perform
  end

  def perform
    return project.update_attributes(channels: [channel]) if project.able_to_move_to_channel?
    false
  end

  attr_reader :project, :channel
end
