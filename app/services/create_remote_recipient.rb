class CreateRemoteRecipient
  def initialize(account_info)
    @account_info = account_info
  end

  def call
    PagarMe::Recipient.create(recipient_params)
  end

  private

  def recipient_params
    {
      transfer_interval: 'monthly',
      transfer_day: Time.current.day,
      transfer_enabled: true,
      bank_account: @account_info
    }
  end
end
