class RecurringContribution::Transactions::FindOrCreate
  attr_reader :transaction_code

  def initialize(transaction_code)
    @transaction_code = transaction_code
  end

  def self.process(transaction_code)
    new(transaction_code).process
  end

  def process
    Transaction.find_by(transaction_code: transaction_code) || process_new_transaction
  end

  private

  def process_new_transaction
    pagarme_transaction = Pagarme::API.find_transaction(transaction_code)
    juntos_subscription = Subscription.find_by(subscription_code: pagarme_transaction.subscription_id)

    Transaction.transaction do
      disable_current_transaction(juntos_subscription)
      create_transaction(pagarme_transaction, juntos_subscription)
    end
  end

  def disable_current_transaction(juntos_subscription)
    return unless juntos_subscription.current_transaction

    juntos_subscription.current_transaction.update(current: false)
  end

  def create_transaction(pagarme_transaction, juntos_subscription)
    Transaction.create({
      transaction_code: pagarme_transaction.id,
      status: pagarme_transaction.status,
      amount: pagarme_transaction.amount,
      payment_method: pagarme_transaction.payment_method,
      subscription: juntos_subscription,
      current: true
    })
  end
end
