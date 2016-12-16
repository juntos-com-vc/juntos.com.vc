class Projects::RemindersController < ApplicationController
  before_filter :authenticate_user!

  def create
    if Project::ReminderService.call(current_user, project)
      flash[:notice] = t('projects.reminder.ok')
    end

    redirect_to project_by_slug_path(project.permalink)
  end

  def destroy
    project.notifications.where(template_name: 'reminder', user_id: current_user.id).destroy_all
    project.delete_from_reminder_queue(current_user.id)

    redirect_to project_by_slug_path(project.permalink)
  end

  protected

  def project
    @project ||= Project.find params[:id]
  end
end
