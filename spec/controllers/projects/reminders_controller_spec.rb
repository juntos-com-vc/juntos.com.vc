require 'rails_helper'

RSpec.describe Projects::RemindersController, type: :controller do

  let(:user)    { create(:user) }
  let(:project) { create(:project) }

  before { sign_in user }

  describe '#POST' do
    before { allow(ReminderProjectWorker).to receive(:perform_at) }

    it 'redirects to project_by_slug_path' do
      post(:create, id: project.id)

      expect(response).to redirect_to project_by_slug_path(project.permalink)
    end

    context 'when the user has invalid contribution for the project' do
      before { allow(Project::ReminderService).to receive(:call).and_return(true) }

      it 'should not create a reminder' do
        post(:create, id: project.id)

        expect(flash[:notice]).to eq(I18n.t('projects.reminder.ok'))
      end
    end
  end
end
