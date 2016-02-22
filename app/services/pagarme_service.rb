class PagarmeService
  def self.create_recipient(bank_account)
    recipient = recipient_params(bank_account)

    request = PagarMe::Request.new('/recipients', 'POST')
    request.parameters = recipient

    request.run
  end

  def self.find_recipient_by_id(id)
    request = PagarMe::Request.new('/recipients' + "/#{id}", 'GET')
    response = request.run
    PagarMe::Util.convert_to_pagarme_object(response)
  end

  def self.update_recipient(id, bank_account)
    request = PagarMe::Request.new('/recipients' + "/#{id}", 'PUT')
    request.parameters = {bank_account: bank_account}
    response = request.run

    PagarMe::Util.convert_to_pagarme_object(response)
  end

  def self.create_bank_account(account_info)
    bank_account = PagarMe::BankAccount.new(account_info).create

    bank_account["id"]
  end

  private

  def self.recipient_params(bank_account)
    recipient = {
      transfer_interval: 'monthly',
      transfer_day: Time.current.day,
      transfer_enabled: true,
    }

    recipient.merge(bank_account: bank_account)
  end
end
