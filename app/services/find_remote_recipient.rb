class FindRemoteRecipient
  def self.call(id)
    PagarMe::Recipient.find id
  end
end
