class Project::SubscriptionsPledgedValueQuery
  attr_reader :subscriptions

  def initialize(project)
    @subscriptions = project.subscriptions.paid.includes(:plan)
  end

  def self.call(project)
    new(project).call
  end

  def call
    subscriptions.map(&:plan_formatted_amount).sum
  end
end
