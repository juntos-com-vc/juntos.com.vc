require 'rails_helper'

RSpec.describe RecurringContributionService do
  describe '.create' do
    let(:contribution) { create :contribution }
    let(:recurring_contribution) do
      create :recurring_contribution, {
        project: contribution.project,
        user: contribution.user,
        value: contribution.project_value
      }
    end

    before do
      allow(RecurringContribution)
        .to receive(:create).and_return(recurring_contribution)
    end

    subject { described_class.create contribution }

    it 'creates a new recurring contribution' do
      expect(RecurringContribution)
        .to receive(:create)
        .with({
          project: contribution.project,
          user: contribution.user,
          value: contribution.project_value
        })

      subject
    end

    it 'updates the contribution record in order to add a reference' do
      expect {subject}
        .to change {contribution.reload.recurring_contribution_id}
        .from(nil).to(recurring_contribution.id)
    end
  end

  describe '.create_contribution' do
    let(:recurring_contribution) { create :recurring_contribution }
    let(:transaction) do
      double(PagarMe::Transaction, {
        status: 'paid',
        tid: '1457977601018',
        cost: 50
      })
    end

    subject do
      described_class.create_contribution(recurring_contribution, transaction)
    end

    before do
      allow(Contribution).to receive(:create)
    end

    it 'creates a new contribution resource' do
      expect(Contribution).to receive(:create)
        .with({
          project: recurring_contribution.project,
          user: recurring_contribution.user,
          project_value: recurring_contribution.value,
          payment_method: 'PagarMe',
          payment_id: transaction.tid,
          payment_service_fee: transaction.cost.to_f / 100
        })

      subject
    end
  end

  describe '.cancel' do
    let(:contribution) do
      create :recurring_contribution,
        credit_card: 'card_cilsa7d9o005n0x6dvu5cc111'
    end

    subject { described_class.cancel(contribution.project, contribution.user) }

    before do
      allow_any_instance_of(RecurringContribution)
        .to receive(:cancel).and_return(true)
    end

    it 'calls the cancel method on the resource' do
      expect_any_instance_of(RecurringContribution).to receive(:cancel)
      subject
    end
  end
end
