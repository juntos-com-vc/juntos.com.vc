class CancelRecurringContribution
  def initialize(recurring_contribution)
    @recurring_contribution = recurring_contribution
  end

  def call
    @recurring_contribution.cancel

    contribution = @recurring_contribution.contributions.first

    contribution.notify_to_contributor(:recurring_contribution_canceled)

    contribution.notify_to_backoffice(:contribution_canceled_after_confirmed) 
  end
end
