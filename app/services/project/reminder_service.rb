class Project::ReminderService
  REMINDER_TIME_LEFT = 48.hours

  def initialize(current_user, project)
    @current_user = current_user
    @project = project
  end

  def self.call(current_user, project)
    new(current_user, project).call
  end

  def call
    if accept_remind_me?
      reminder_at = @project.expires_at - REMINDER_TIME_LEFT
      ReminderProjectWorker.perform_at(reminder_at, @current_user.id, @project.id)
    end
  end

  private

  def accept_remind_me?
    user_has_invalid_contribution? && user_not_in_reminder? && project_has_expires_at?
  end

  def user_has_invalid_contribution?
    !@current_user.has_valid_contribution_for_project?(@project.id)
  end

  def user_not_in_reminder?
    !@project.user_already_in_reminder?(@current_user.id)
  end

  def project_has_expires_at?
    !@project.expires_at.nil?
  end
end
