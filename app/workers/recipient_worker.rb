class RecipientWorker
  include Sidekiq::Worker

  def perform (project_id, account_info)
    Project.find(project_id).update_attributes(recipient_job_running: true)

    PagarmeService.process(project_id, account_info)
  end
end
