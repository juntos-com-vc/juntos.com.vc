class Channels::ProjectsController < Channels::BaseController
  def supported_by_channel
    render json: channel.projects.map(&:channel_json)
  end
end
