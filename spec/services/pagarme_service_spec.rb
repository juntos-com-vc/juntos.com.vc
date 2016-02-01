require 'rails_helper'

RSpec.describe PagarmeService do
  describe '.create_recipient' do
    let(:request) { instance_double('PagarMe::Request') }
    let(:recipient) {{
      transfer_interval: 'monthly',
      transfer_day: 7,
      transfer_enabled: true,
      bank_account: {
        bank_code: '001',
        agencia: '0001',
        conta: '000001',
        conta_dv: '00',
        document_number: '111.111.111-11',
        legal_name: 'Juntos com você API'
      }
    }}

    subject { described_class.create_recipient(recipient) }

    before do
      allow(PagarMe::Request).to receive(:new).and_return(request)
      allow(request).to receive_messages(:parameters= => nil, :run => nil)
    end

    it 'instantiates a new Request object' do
      expect(PagarMe::Request).to receive(:new).with('/recipients', 'POST')

      subject
    end

    it 'passes the correct parameters to the request' do
      expect(request).to receive(:parameters=).with(recipient)

      subject
    end

    it 'triggers the request' do
      expect(request).to receive(:run)

      subject
    end
  end
end
