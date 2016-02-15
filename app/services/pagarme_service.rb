class PagarmeService
  def self.create_recipient(recipient)
    request = PagarMe::Request.new('/recipients', 'POST')
    request.parameters = recipient

    request.run
  end

  def self.find_recipient_by_id(id)
    request = PagarMe::Request.new('/recipients' + "/#{id}", 'GET')
    response = request.run
    PagarMe::Util.convert_to_pagarme_object(response)
  end
end
