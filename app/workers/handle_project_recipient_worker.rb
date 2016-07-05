class HandleProjectRecipientWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(project_id, bank_account_params)
    project = Project.find(project_id)

    if project.recipient
      UpdateRemoteRecipient.new(bank_account_params).call(project.recipient)
    else
      recipient = CreateRemoteRecipient.new(bank_account_params).call
      project.update_attributes(recipient: recipient.id)
    end
  end
end
