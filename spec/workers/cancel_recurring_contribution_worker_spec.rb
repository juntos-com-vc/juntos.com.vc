require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe CancelRecurringContributionWorker do
  describe '#perform' do
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

    it 'should notify office and financial administrator about it' do

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

      Sidekiq::Testing.inline! do
        CancelRecurringContributionWorker.perform_async(recurring_contribution.id)
      end
    end
  end
end
