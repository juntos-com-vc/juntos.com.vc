require 'rails_helper'

RSpec.describe CreateRecurringContribution do
  describe '#call' do
    let(:contribution) { create :contribution }

    it 'creates a new recurring contribution' do
      expect { CreateRecurringContribution.new(contribution).call }
        .to change(RecurringContribution, :count).by(1)
    end

    it 'updates the contribution record in order to add a reference' do
      expect(contribution).to receive(:update_attributes)

      CreateRecurringContribution.new(contribution).call
    end
  end
end
