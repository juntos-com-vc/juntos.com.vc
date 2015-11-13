class SubgoalsController < ApplicationController
  after_filter :verify_authorized, except: %i[index]
  inherit_resources
  belongs_to :project
  respond_to :html, :json

  def index
    render layout: false
  end

  def new
    @subgoal = Subgoal.new(project: parent)
    authorize @subgoal
    render layout: false
  end

  def edit
    authorize resource
    render layout: false
  end

  def update
    authorize resource
    update!(notice: t('project.update.success')) { project_by_slug_path(permalink: parent.permalink) + '#dashboard_subgoals' }
  end

  def create
    @subgoal = Subgoal.new(params[:subgoal].merge(project: parent))
    authorize resource
    create!(notice: t('project.update.success')) { project_by_slug_path(permalink: parent.permalink) + '#dashboard_subgoals' }
  end

  def destroy
    authorize resource
    destroy! { project_by_slug_path(permalink: resource.project.permalink) }
  end

  def sort
    authorize resource
    resource.update_attribute :row_order_position, params[:subgoal][:row_order_position]
    render nothing: true
  end

  private
  def permitted_params
    params.permit(policy(resource).permitted_attributes)
  end
end
