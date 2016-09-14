class CancelRecurringContributionWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(recurring_contribution_id)
    recurring_contribution = RecurringContribution.find(recurring_contribution_id).contributions.first

    recurring_contribution
      .notify_to_contributor(:recurring_contribution_canceled)

    recurring_contribution
      .notify_to_backoffice(:contribution_canceled_after_confirmed) 
  end
end
