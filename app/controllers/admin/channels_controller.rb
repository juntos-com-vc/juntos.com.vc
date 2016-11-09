class Admin::ChannelsController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  defaults resource_class: Channel, collection_name: 'channels', instance_name: 'channel'

  def update
    update! { admin_channels_path }
  end

  def new
    super
    binding.pry
  end

  def create
    @profile = Channel.new channel_params
    binding.pry
    if @profile.save
      redirect_to admin_channels_path
    else
      render :new
    end
  end

  def channel_params
    params.require(:channel).permit(:name, :permalink, :recurring, :custom_submit_text, :description, :category_id)
  end

end
