require 'rails_helper'

RSpec.describe UpdateRemoteRecipient do
  describe '#call' do
    context 'when bank account has same document number' do
      it 'update bank account in recipient' do
        recipient_id = 're_ciknzf3jp003eyn6erpmwarkk' 
        account_info  = {
          bank_code: '001',
          agencia: '0001',
          conta: '000001',
          conta_dv: '00',
          document_number: '111.111.111-11',
          legal_name: 'Juntos com você API'
        }

        recipient = UpdateRemoteRecipient.new(account_info)
        
        return_bank_account = double(id: 1)
        return_recipient = double
        
        expect(FindRemoteRecipient).to receive(:call)
          .with(recipient_id)
          .and_return(return_recipient)

        expect(PagarMe::BankAccount).to receive(:create)
          .with(account_info)
          .and_return(return_bank_account)

        expect(return_recipient).to receive(:bank_account_id=)
          .with(return_bank_account.id)
        
        expect(return_recipient).to receive(:save)
          .and_return(return_recipient)

        result = recipient.call(recipient_id)

        expect(result).to eq return_recipient
      end
    end
  end
end
