require 'rails_helper'

RSpec.describe RecurringPaymentService do
  let(:recurring_contribution) { create :recurring_contribution }
  let(:card) { double('PagarMe card', id: 'card_cilsa7d9o005n0x6dvu5cc111') }
  let(:card_hash) do
    '100075_XYFstXr1dD/+9VMNH49wW9DuLt8g11JSV8nxVmlqarmMk7UywlGK+FjYvPTNE3Wr5b0n
    K3N+1vo3QZ7w8QO/BveEqzWwLTt8D29HEeYFGQYMgMB24efpcTyfxuXTGF0Ldz0tHyDhuKf100yq
    OyWgEbo4fUYtmGE9LbqPd6te2tS3eFVgu7cn30QZAw5cSNMGo6E9qrcoviP8uxTA4BP3lFyvJ62A
    8MS/N1IaNNJmLrqFN8jciCqd8EEDPsWCbBS7k7pH8g2Mf9s2q3iELZuZVopqkrxiUYKNCmRVovok
    qB4LnYQIgmbRo0dk0EEAk5dc+OXbMQ0Y1x2iW8CUu5Y/sQ=='
  end

  before do
    allow(PagarMe::Card).to receive(:new).and_return(card)
    allow(card).to receive(:create)
  end

  describe '.create_card' do
    subject { described_class.create_card(recurring_contribution, card_hash) }

    it 'creates a new credit_card using PagarMe' do
      expect(PagarMe::Card).to receive(:new).with(card_hash: card_hash)
      subject
    end

    it 'updates the recurring contribution in order to add credit card ID' do
      expect { subject }
        .to change { recurring_contribution.reload.credit_card }
        .from(nil).to(card.id)
    end
  end

  describe '.perform' do
    let(:contribution) { create :contribution }
    let(:project_recipient) { recurring_contribution.project.recipient }
    let(:transaction) do
      double(PagarMe::Transaction, {
        status: 'paid',
        tid: '1457977601018',
        cost: 50
      })
    end
    let(:create_contribution_instance) { double(call: contribution) }

    subject { described_class.perform(recurring_contribution.id) }

    before do
      allow(RecurringContribution)
        .to receive(:find).and_return(recurring_contribution)

      allow(PagarMe::Transaction).to receive(:new).and_return(transaction)
      allow(PagarMe::Card).to receive(:find_by_id).and_return(card)
      allow(described_class).to receive(:create_card)
      allow(transaction).to receive(:charge)
      allow(CreateContribution).to receive(:new)
        .with(recurring_contribution, transaction)
        .and_return(create_contribution_instance)
    end

    context 'when it is a new recurring contribution' do
      subject do
        described_class.perform(recurring_contribution.id,
                              contribution, card_hash)
      end

      it 'creates a new card to be used on current and future transactions' do
        expect(described_class)
          .to receive(:create_card).with(recurring_contribution,card_hash)

        subject
      end

      it 'updates the contribution resource' do
        expect { subject }
          .to change { contribution.reload.payment_method }
              .from(nil).to('PagarMe')
          .and change { contribution.reload.payment_id }
              .from(contribution.payment_id).to(transaction.tid)
          .and change { contribution.reload.payment_service_fee }
              .from(nil).to(transaction.cost.to_f / 100)
      end
    end

    it 'searches for the recurring contribution' do
      expect(RecurringContribution)
        .to receive(:find).with(recurring_contribution.id)

      subject
    end

    it 'instantiates a new transaction' do
      expect(PagarMe::Transaction)
        .to receive(:new)
        .with({
          amount: recurring_contribution.value.to_f * 100,
          card: card,
          split_rules: [{
            recipient_id: project_recipient,
            percentage: 100,
            liable: true,
            charge_processing_fee: true
          }]
        })

      subject
    end

    it 'sends the transaction to PagarMe' do
      expect(transaction).to receive(:charge)

      subject
    end

    it 'creates a new contribution resource' do
      subject

      expect(create_contribution_instance).to have_received(:call).once
    end
  end
end
