require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe RecipientWorker do
  describe '.perform_async' do
    let(:project) { create :project }
    let(:account_info) do
      {
        "bank_code" => '001',
        "agencia" => '0001',
        "conta" => '000001',
        "conta_dv" => '00',
        "document_number" => '111.111.111-11',
        "legal_name" => 'Juntos com você API'
      }
    end

    subject { described_class.perform_async(project.id, account_info) }

    it 'enqueues a job' do
      expect {subject}.to change(described_class.jobs, :size).by(1)
    end

    it 'calls PagarmeService' do
      Sidekiq::Testing.inline! do
        expect(PagarmeService)
          .to receive(:process).with(project.id, account_info)

        subject
      end
    end
  end
end
