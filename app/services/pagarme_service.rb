class PagarmeService
  def self.process(project_id, account_info)
    project = Project.find(project_id)

    if project.recipient
      update_recipient_bank_account(project.recipient, account_info)
    else
      recipient = create_recipient(account_info)
      project.update_attributes(recipient: recipient['id'])
    end

    project.update_attributes(recipient_job_running: false)
  end

  def self.create_recipient(account_info)
    recipient = recipient_params(account_info)

    request = PagarMe::Request.new('/recipients', 'POST')
    request.parameters = recipient

    request.run
  end

  def self.find_recipient_by_id(id)
    request = PagarMe::Request.new('/recipients' + "/#{id}", 'GET')
    response = request.run
    PagarMe::Util.convert_to_pagarme_object(response)
  end

  def self.update_recipient_bank_account(id, account_info)
    bank_account_id = create_bank_account(account_info)

    request = PagarMe::Request.new('/recipients' + "/#{id}", 'PUT')
    request.parameters = {bank_account_id: bank_account_id}
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
