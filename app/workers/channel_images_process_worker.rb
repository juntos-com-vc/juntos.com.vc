class ChannelImagesProcessWorker
  include Sidekiq::Worker

  def perform(channel_id, uploaded_image_url, uploaded_email_header_url)
    channel = Channel.find(channel_id)

    channel.update_attributes({
      original_image_url: nil,
      original_email_header_image_url: nil,
      remote_image_url: uploaded_image_url,
      remote_email_header_image_url: uploaded_email_header_url,
      image_processing: false,
      email_header_image_processing: false
    })
  end
end
