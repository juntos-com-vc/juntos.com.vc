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
    successful_projects = resource.projects.with_state('successful')

    @total_pledged = successful_projects.map(&:project_total).compact.sum(&:pledged).to_f
    @total_projects = successful_projects.count
    @total_contributions = successful_projects.joins(:contributions).count
  end
end
