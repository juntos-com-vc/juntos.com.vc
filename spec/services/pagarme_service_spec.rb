require 'rails_helper'

RSpec.describe PagarmeService do
  describe 'operations with Request class' do
    let(:request) { instance_double('PagarMe::Request') }

    before do
      allow(PagarMe::Request).to receive(:new).and_return(request)
    end

    describe '.create_recipient' do
      let(:bank_account) {{
        bank_code: '001',
        agencia: '0001',
        conta: '000001',
        conta_dv: '00',
        document_number: '111.111.111-11',
        legal_name: 'Juntos com você API'
      }}

      let(:recipient) {{
        transfer_interval: 'monthly',
        transfer_day: Time.current.day,
        transfer_enabled: true,
        bank_account: bank_account
      }}

      subject { described_class.create_recipient(bank_account) }

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

    describe '.update_recipient_bank_account' do
      let(:recipient_id) { 're_ciknzf3jp003eyn6erpmwarkk' }
      let(:bank_account_id) { 11585644 }
      let(:account_info) {{
        'bank_code' => '341',
        'agencia' => '007',
        'agencia_dv' => nil,
        'conta' => '077',
        'conta_dv' => 77,
        'document_number' => '74458396820',
        'legal_name' => 'TEST BANK ACCOUNT',
      }}

      subject {
        described_class.update_recipient_bank_account recipient_id, account_info
      }

      before do
        allow(request).to receive_messages(:parameters= => nil, :run => nil)
        allow(PagarmeService).to receive(:create_bank_account)
                                        .and_return(bank_account_id)
      end

      it 'instantiates a new Request object' do
        expect(PagarMe::Request)
          .to receive(:new).with('/recipients/' +recipient_id, 'PUT')

        subject
      end

      it 'passes the correct parameters to the request' do
        expect(request)
          .to receive(:parameters=).with(bank_account_id: bank_account_id)

        subject
      end

      it 'triggers the request' do
        expect(request).to receive(:run)

        subject
      end
    end
  end

  describe 'create_bank_account' do
    let(:account_instance) { instance_double('PagarMe::BankAccount') }
    let(:bank_account) {{
      'object' => 'bank_account',
      'id' => 11585644,
      'document_type' => 'cpf',
      'charge_transfer_fees' => true,
      'date_created' => '2016-02-22T14:49:49.000Z'
    }.merge(account_info)}

    let(:account_info) {{
      'bank_code' => '341',
      'agencia' => '007',
      'agencia_dv' => nil,
      'conta' => '077',
      'conta_dv' => 77,
      'document_number' => '74458396820',
      'legal_name' => 'TEST BANK ACCOUNT',
    }}

    subject { described_class.create_bank_account account_info }

    before do
      allow(PagarMe::BankAccount).to receive(:new).and_return(account_instance)
      allow(account_instance).to receive(:create).and_return(bank_account)
    end

    it 'pass the account information as an argument to a new bank account' do
      expect(PagarMe::BankAccount).to receive(:new).with(account_info)

      subject
    end

    it { is_expected.to eq bank_account['id'] }

  end
end
