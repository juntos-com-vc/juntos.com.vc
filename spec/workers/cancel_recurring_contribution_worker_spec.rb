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

      create(:user, email: CatarseSettings[:email_payments])
    end

    it 'sends email to office and financial administrator about it' do
      expect(ActionMailer::Base.deliveries.count).to be_zero

      Sidekiq::Testing.inline! do
        CancelRecurringContributionWorker.perform_async(recurring_contribution.id)
      end

      expect(ActionMailer::Base.deliveries.count).to eq 2

      email_data = ActionMailer::Base.deliveries.map do |delivery|
        { subject: delivery.subject, to: delivery.to }
      end
      expect(email_data).to include(
        {
          subject: 'Apoio cancelado após ser confirmado',
          to: ['financial@administrator.com']
        },
        {
          subject: "Cancelado: apoio para o projeto My project",
          to: ['contributor@project.com']
        }
      )
    end
  end
end
