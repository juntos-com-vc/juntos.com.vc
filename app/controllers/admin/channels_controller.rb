class Admin::ChannelsController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  defaults resource_class: Channel, collection_name: 'channels', instance_name: 'channel'

  def create
    @channel = Channel.new(channel_params)
    create! { admin_channels_path }
  end

  def update
    @channel = Channel.find(params[:id])
    if @channel.update(channel_params)
      redirect_to admin_channels_path
    else
      flash[:alert] = @channel.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def channel_params
    allow_attributes = %i(name email description recurring custom_submit_text permalink visible category_id)
    params[:channel].permit(allow_attributes)
  end
end
