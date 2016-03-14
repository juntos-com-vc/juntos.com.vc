class RecurringContributionService
  def self.create(contribution)
    recurring_contribution = RecurringContribution.create({
      project: contribution.project,
      user: contribution.user,
      value: contribution.project_value.to_f
    })

    contribution.update_attributes({
      recurring_contribution: recurring_contribution
    })
  end

  def self.create_contribution(recurring_contribution, transaction)
    Contribution.create({
      project: recurring_contribution.project,
      user: recurring_contribution.user,
      project_value: recurring_contribution.value,
      payment_method: 'PagarMe',
      payment_id: transaction.tid,
      payment_service_fee: transaction.cost.to_f / 100
    })
  end
end
