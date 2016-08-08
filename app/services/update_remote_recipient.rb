class UpdateRemoteRecipient
  def initialize(account_info)
    @account_info = account_info
  end

  def call(id)
    recipient = FindRemoteRecipient.call(id)
    bank_account = create_bank_account

    recipient.bank_account_id = bank_account.id
    recipient.save
  end

  private

  def create_bank_account
    PagarMe::BankAccount.create(@account_info)
  end
end
