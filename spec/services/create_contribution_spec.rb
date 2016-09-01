require 'rails_helper'

RSpec.describe CreateContribution do
  describe '#call' do
    let(:recurring_contribution) { create :recurring_contribution }

    let(:transaction) {
      double(PagarMe::Transaction, {
        status: 'paid',
        tid: '1457977601018',
        cost: 50
      })
    }

    it 'creates a new contribution out of recurring contribution' do
      expect { CreateContribution.new(recurring_contribution, transaction).call }
        .to change(Contribution, :count).by(1)
    end
  end
end
