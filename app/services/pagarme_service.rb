class PagarmeService
  def self.create_recipient(recipient)
    request = PagarMe::Request.new('/recipients', 'POST')
    request.parameters = recipient

    request.run
  end
end
