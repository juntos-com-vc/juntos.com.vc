require 'rails_helper'

RSpec.describe CancelRecurringContribution do
  describe '#call' do
    let(:recurring_contribution) {
      create :recurring_contribution,
        credit_card: 'card_cilsa7d9o005n0x6dvu5cc111'
    }

    it 'calls cancel method in resource' do
      expect(recurring_contribution).to receive(:cancel)

      CancelRecurringContribution.new(recurring_contribution).call
    end

    it 'start job to notify contributor and financial administrator' do
      expect(CancelRecurringContributionWorker).to receive(:perform_async).with(recurring_contribution.id)

      CancelRecurringContribution.new(recurring_contribution).call
    end
  end
end
