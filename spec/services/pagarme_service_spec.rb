require 'rails_helper'

RSpec.describe PagarmeService do
  let(:request) { instance_double('PagarMe::Request') }

  before do
    allow(PagarMe::Request).to receive(:new).and_return(request)
  end

  describe '.create_recipient' do
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

  describe '.find_recipient_by_id' do
    let(:recipient_response) {{
      "object" => "recipient",
      "id" => "re_ciknzf3jp003eyn6erpmwarkk",
      "bank_account" => {
        "object" => "bank_account",
        "id" => 11445923,
        "bank_code" => "033",
        "agencia" => "2345",
        "agencia_dv" => "1",
        "conta" => "0123456",
        "conta_dv" => "7",
        "document_type" => "cnpj",
        "document_number" => "12275141000104",
        "legal_name" => "ADMIN",
        "charge_transfer_fees" => true,
        "date_created" => "2016-02-15T12:53:33.000Z"
      },
      "transfer_enabled" => true,
      "last_transfer" => nil,
      "transfer_interval" => "monthly",
      "transfer_day" => 15,
      "automatic_anticipation_enabled" => false,
      "anticipatable_volume_percentage" => 0,
      "date_created" => "2016-02-15T12:53:33.000Z",
      "date_updated" => "2016-02-15T12:53:33.000Z"
    }}

    let!(:recipient_object) {
      PagarMe::Util.convert_to_pagarme_object(recipient_response)
    }

    subject { described_class.find_recipient_by_id(recipient_object.id) }

    before do
      allow(request).to receive_messages(run: recipient_response)
    end

    it 'instantiates a new Request object' do
      expect(PagarMe::Request)
        .to receive(:new).with('/recipients/' +recipient_object.id, 'GET')

      subject
    end

    it 'triggers the request' do
      expect(request).to receive(:run)

      subject
    end
  end
end
