class CancelRecurringContributionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(recurring_contribution_id)
    recurring_contribution = RecurringContribution.find(recurring_contribution_id)

    recurring_contribution.contributions.first
      .notify_to_backoffice(:contribution_canceled_after_confirmed).deliver
    
    recurring_contribution.contributions.first
      .notify_to_contributor(:contribution_canceled).deliver
  end
end
