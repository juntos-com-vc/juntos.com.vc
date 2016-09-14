class CreateContribution
  def initialize(recurring_contribution, transaction)
    @recurring_contribution = recurring_contribution
    @transaction = transaction
  end
 
  def call
    Contribution.create({
      project: @recurring_contribution.project,
      user: @recurring_contribution.user,
      project_value: @recurring_contribution.value,
      payment_method: 'PagarMe',
      payment_id: @transaction.tid,
      payment_service_fee: @transaction.cost.to_f / 100
    })
  end
end
