require 'rails_helper'

RSpec.describe Project::ReminderService do
  let(:user)        { create(:user) }
  let(:project)     { create(:project, online_date: Time.current, online_days: 10) }
  let(:reminder_at) { project.expires_at - 48.hours }

  before { allow(ReminderProjectWorker).to receive(:perform_at) }

  describe '.call' do
    context 'when the user is not in remind me' do
      before { Project::ReminderService.call(user, project) }

      it 'should create a reminder' do
        expect(ReminderProjectWorker).to have_received(:perform_at).
          with(reminder_at, user.id, project.id)
      end
    end

    context 'when the user has invalid contribution for the project' do
      before do
        create(:contribution, :confirmed, project: project, user: user)

        Project::ReminderService.call(user, project)
      end

      it 'should not create a reminder' do
        expect(ReminderProjectWorker).not_to have_received(:perform_at)
      end
    end

    context 'when the user is already in remind me' do
      before do
        allow(project).to receive(:user_already_in_reminder?).and_return(true)

        Project::ReminderService.call(user, project)
      end

      it 'should not create a reminder' do
        expect(ReminderProjectWorker).not_to have_received(:perform_at)
      end
    end

    context 'when project does not have expires_at' do
      let(:project) { create(:project, online_date: nil) }
      before        { Project::ReminderService.call(user, project) }

      it 'should not create a reminder' do
        expect(ReminderProjectWorker).not_to have_received(:perform_at)
      end
    end
  end
end
