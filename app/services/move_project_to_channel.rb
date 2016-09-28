class MoveProjectToChannel
  def initialize(project_params,channel_params)
    @project = Project.find(project_params)
    @channel = Channel.find(channel_params)
  end

  def call
    if project.channels.empty?
      project.channels << channel
    end
  end

  attr_reader :project, :channel
end
