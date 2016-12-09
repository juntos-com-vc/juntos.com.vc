class Channels::ProfilesController < Channels::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  actions :show, :edit, :update
  custom_actions resource: [:how_it_works, :terms, :privacy, :contacts]
  after_filter :verify_authorized, except: [:how_it_works, :show, :terms, :privacy, :contacts]
  before_action :show_statistics, only: [:show]

  def edit
    authorize resource
    edit!
  end

  def update
    authorize resource
    update!
  end

  def resource
    @profile ||= channel
  end

  private

  def show_statistics
    @channel_statistics = ChannelStatisticsQuery.new(resource)
  end
end
