class UpdateContributionState

  def initialize(contribution)
    @contribution = contribution
  end

  def call(transaction_status)
    case transaction_status
      when 'waiting_payment' 
        @contribution.waiting
      when 'paid', 'authorized' 
        @contribution.confirm
      when 'pending_refund'
        @contribution.request_refund
      when 'refunded'
        @contribution.refund
      when 'refused'
        @contribution.invalid
    end
  end
end
