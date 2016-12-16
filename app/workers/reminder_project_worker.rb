class ReminderProjectWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(user_id, project_id)
    user = User.find user_id
    project = Project.find project_id

    project.notify_once(:reminder, user, project)
  end
end
