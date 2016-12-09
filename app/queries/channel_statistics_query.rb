class ChannelStatisticsQuery
  delegate :count, to: :successful_projects, prefix: :successful_projects
  delegate :count, to: :contributions, prefix: :contributions

  def initialize(channel)
    @channel = channel
  end

  def total_pledged
    project_total_pledged_values.sum.to_f
  end

  private

  def projects
    @channel.projects.valid_for_channel_statistics
  end

  def project_total_pledged_values
    ProjectTotal.where( project_id: projects ).pluck(:pledged)
  end

  def successful_projects
    projects.successful
  end

  def contributions
    Contribution.valid_for_channel_statistics_by_projects(projects)
  end
end
