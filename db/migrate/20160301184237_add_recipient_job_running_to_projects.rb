class AddRecipientJobRunningToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :recipient_job_running, :boolean, default: false
  end
end
