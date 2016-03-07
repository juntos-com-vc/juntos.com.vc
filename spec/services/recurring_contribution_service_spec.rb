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
end
