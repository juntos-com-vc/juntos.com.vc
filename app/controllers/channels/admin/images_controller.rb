class Channels::Admin::ImagesController < Channels::Admin::BaseController
  defaults resource_class: ChannelImage

  def update
    update! { channels_admin_images_path }
  end

  def create
    create! { channels_admin_images_path }
  end

  def begin_of_association_chain
    channel
  end

  def collection
    @images ||= apply_scopes(end_of_association_chain.ordered.page(params[:page]))
  end
end
