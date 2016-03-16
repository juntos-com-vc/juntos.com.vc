require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe RecurringPaymentWorker do
  describe '.perform_async' do
    let!(:contribution) do
      create :recurring_contribution,
              credit_card: 'card_cilsa7d9o005n0x6dvu5cc111'
    end

    subject { described_class.perform_async }

    it 'enqueues a job' do
      expect { subject }.to change(described_class.jobs, :size).by(1)
    end

    it 'calls RecurringPaymentService' do
      Sidekiq::Testing.inline! do
        expect(RecurringPaymentService)
          .to receive(:perform).with(contribution.id)

        subject
      end
    end
  end
end
