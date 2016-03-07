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
end
