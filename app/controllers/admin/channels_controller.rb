class Admin::ChannelsController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  defaults resource_class: Channel, collection_name: 'channels', instance_name: 'channel'

  def create
    create! { admin_channels_path }
  end

  def update
    update! { admin_channels_path }
  end

end
