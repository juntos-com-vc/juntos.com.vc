require 'rails_helper'

RSpec.describe CancelRecurringContribution do
  describe '#call' do
    let(:contributor) { create :user, email: 'contributor@project.com' }
    let(:project) { create :project, name: 'My project' }
    let(:contribution) { create :contribution, project: project, user: contributor }
    let(:recurring_contribution) {
      create :recurring_contribution, {
        project: contribution.project,
        user: contribution.user,
        value: contribution.project_value,
        contributions: [contribution]
      }
    }

    before do
      CatarseSettings[:email_payments] = 'financial@administrator.com'

      @financial_administrator = create(:user, email: CatarseSettings[:email_payments])
    end

    it 'calls cancel method in resource' do
      expect(recurring_contribution).to receive(:cancel)

      CancelRecurringContribution.new(recurring_contribution).call
    end

    it 'should notify contributor and financial administrator' do
      expect(ContributionNotification).to receive(:notify_once).with(
        :recurring_contribution_canceled,
        contribution.user,
        contribution,
        {}
      )

      expect(ContributionNotification).to receive(:notify_once).with(
        :contribution_canceled_after_confirmed,
        @financial_administrator,
        contribution,
        {}
      )

      CancelRecurringContribution.new(recurring_contribution).call
    end
  end
end
