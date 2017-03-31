class Project::SubscriptionsPledgedValueQuery
  attr_reader :subscriptions

  def initialize(project)
    @subscriptions = project.subscriptions.includes(:plan).with_paid_transactions
  end

  def self.call(project)
    new(project).call
  end

  def call
    subscriptions.inject(0) do |pledged_value, subscription|
      pledged_value + (subscription.transactions.length * subscription.plan_formatted_amount)
    end
  end
end
