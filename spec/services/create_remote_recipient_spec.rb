require 'rails_helper'

RSpec.describe CreateRemoteRecipient do
  describe '#call' do
    context 'when data is correct' do
      it 'create a recipient in pagarme' do
        Timecop.freeze do
          account_info  = {
            bank_code: '001',
            agencia: '0001',
            conta: '000001',
            conta_dv: '00',
            document_number: '111.111.111-11',
            legal_name: 'Juntos com você API'
          }

          recipient_params = {
            transfer_interval: 'monthly',
            transfer_day: Time.current.day,
            transfer_enabled: true,
            bank_account: account_info
          }

          recipient = CreateRemoteRecipient.new(account_info)
         
          return_value = double

          expect(PagarMe::Recipient).to receive(:create)
            .with(recipient_params)
            .and_return(return_value)
          
          result = recipient.call

          expect(result).to eq return_value
        end
      end
    end
  end
end
