class ProjectCoverProcessWorker
  include Sidekiq::Worker

  def perform(project_id, uploaded_image_url, uploaded_cover_url)
    project = Project.find(project_id)

    project.update_attributes({
      original_uploaded_image: nil,
      original_uploaded_cover_image: nil,
      remote_uploaded_image_url: uploaded_image_url,
      remote_uploaded_cover_image_url: uploaded_cover_url,
      image_processing: false,
      cover_image_processing: false
    })
  end
end
