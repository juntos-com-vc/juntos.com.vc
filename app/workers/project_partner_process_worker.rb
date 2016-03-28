class ProjectPartnerProcessWorker
  include Sidekiq::Worker

  def perform(image_id, url)
    image = ProjectPartner.find(image_id)

    image.update_attributes({
      original_image_url: nil,
      remote_image_url: url,
      image_processing: false
    })
  end
end
