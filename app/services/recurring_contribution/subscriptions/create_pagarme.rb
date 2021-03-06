class RecurringContribution::Subscriptions::CreatePagarme
  def initialize(juntos_subscription)
    @juntos_subscription = juntos_subscription
    @payment_method = normalize_payment_method(juntos_subscription.payment_method)
    @plan_id = juntos_subscription.new_value.to_i > 0 ? juntos_subscription.new_value.to_i : juntos_subscription.plan.plan_code
    @user = juntos_subscription.user
    @owner = juntos_subscription.project.user
  end

  def process
    ::Pagarme::API.create_subscription(attributes)
  end

  private
  attr_reader :juntos_subscription, :payment_method, :plan_id, :user

  def attributes
    return default_attributes.merge(credit_card_id) if credit_card?
    default_attributes
  end

  def default_attributes
    {
      plan: ::Pagarme::API.find_plan(plan_id),
      payment_method: payment_method,
      postback_url: postback_url,
      customer: { email: user.email, cpf: user.cpf },
      split_rules: [
        {
          recipient_id: ENV['PAGARME_RECIPIENT_ID'],
          percentage: ENV['PAGARME_SUBSCRIPTION_PERCENTAGE'],
          liable: true,
          charge_processing_fee: true
        } ,
        {
          recipient_id: @juntos_subscription.project.recipient,
          percentage: 100-ENV['PAGARME_SUBSCRIPTION_PERCENTAGE'].to_i,
          liable: true,
          charge_processing_fee: true
        }
      ]
    }
  end

  def credit_card_id
    { card_id: juntos_subscription.credit_card_key }
  end

  def normalize_payment_method(payment_method)
    bank_billet? ? 'boleto' : payment_method
  end

  def credit_card?
    juntos_subscription.payment_method == 'credit_card'
  end

  def bank_billet?
    juntos_subscription.payment_method == 'bank_billet'
  end

  def postback_url
    Rails.application.routes.url_helpers.subscription_status_update_url
  end
end