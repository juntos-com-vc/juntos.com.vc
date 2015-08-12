class Admin::ProjectsController < Channels::Admin::BaseController
  layout 'juntos_bootstrap'

  has_scope :by_user_email, :by_id, :pg_search, :user_name_contains, :with_state, :by_category_id, :order_by, :by_channel
  has_scope :between_created_at, :between_expires_at, :between_online_date, :between_updated_at, :goal_between, using: [ :start_at, :ends_at ]

  before_filter do
    @total_projects = collection.count(:all)
  end

  [:approve, :push_to_draft, :push_to_trash].each do |name|
    define_method name do
      @project = Project.find params[:id]
      @project.send("#{name.to_s}!")
      redirect_to :back
    end
  end

  def index
    respond_to do |format|
      format.html { collection }
      format.csv do
        self.response_body = Enumerator.new do |y|
          unpaginated_collection.copy_to do |line|
            y << line
          end
        end
      end
    end
  end

  def destroy
    @project = Project.find params[:id]
    if @project.can_push_to_trash?
      @project.push_to_trash!
    end

    redirect_to admin_projects_path
  end

  def deny
    @project = Project.find(params[:id])
  end

  def reject
    @project = Project.find(params[:id])
    @project.update_attributes(reject_params)
    @project.reject!
    redirect_to admin_projects_path, notice: 'Projeto rejeitado'
  end

  protected
  def unpaginated_collection
    @scoped_projects = apply_scopes(end_of_association_chain).with_project_totals.without_state('deleted')
    if channel
      @scoped_projects = @scoped_projects.where("id IN (SELECT project_id FROM channels_projects WHERE channel_id = #{channel.id})")
    end
    @scoped_projects
  end

  def collection
    @projects = unpaginated_collection.page(params[:page])
  end

  def reject_params
    params.require(:project).permit(:reject_reason)
  end
end
