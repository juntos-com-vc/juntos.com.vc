require 'rails_helper'

RSpec.describe FindRemoteRecipient do
  describe '.call' do
    it 'finds a recipient in pagarme' do
      recipient_id = 're_ciknzf3jp003eyn6erpmwarkk' 
      returned_recipient = double
      
      expect(PagarMe::Recipient).to receive(:find)
        .with(recipient_id)
        .and_return(returned_recipient)
      
      result = FindRemoteRecipient.call(recipient_id)
      
      expect(result).to eq returned_recipient
    end
  end
end
