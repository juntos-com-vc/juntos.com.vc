class CancelRecurringContribution
  def initialize(recurring_contribution)
    @recurring_contribution = recurring_contribution
  end

  def call
    @recurring_contribution.cancel

    CancelRecurringContributionWorker.perform_async(@recurring_contribution.id)
  end
end
