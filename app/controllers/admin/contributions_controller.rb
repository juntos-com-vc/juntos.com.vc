class Admin::ContributionsController < Admin::BaseController
  layout 'juntos_bootstrap'
  has_scope :project_name_contains, :search_on_payment_data, :with_state
  has_scope :search_on_user, :search_on_acquirer, :by_id, :by_user_id
  has_scope :payer_email_contains, :by_payment_id, :by_key
  has_scope :user_name_contains, :user_email_contains, :user_cpf_contains
  has_scope :credits, type: :boolean
  has_scope :platform_contributions, type: :boolean
  has_scope :between_values, using: [ :start_at, :ends_at ], allow_blank: true
  has_scope :partner_indications, type: :boolean
  before_filter :set_title

  def self.contribution_actions
    %w[confirm pendent refund hide cancel push_to_trash request_refund].each do |action|
      define_method action do
        if resource.send(action)
          flash[:notice] = I18n.t("admin.contributions.messages.successful.#{action}")
        else
          flash[:notice] = t("activerecord.errors.models.contribution")
        end
        redirect_to admin_contributions_path(params[:local_params])
      end
    end
  end
  contribution_actions

  def index
    respond_to do |format|
      format.html { collection }
      format.csv do
        self.response_body = Enumerator.new do |y|
          collection(:json).copy_to do |line|
            y << line
          end
        end
      end
    end
  end

  def change_reward
    resource.change_reward! params[:reward_id]
    flash[:notice] = I18n.t('admin.contributions.messages.successful.change_reward')
    redirect_to admin_contributions_path(params[:local_params])
  end

  def update_user
    @contribution = Contribution.find(params[:id])
  end

  protected
  def set_title
    @title = t("admin.contributions.index.title")
  end

  def permitted_params
    params.permit(contribution: [:user_id, :anonymous])
  end

  def collection(format = :html)
    if current_user.present? && current_user.admin?
      if format == :html
        @contributions = apply_scopes(end_of_association_chain).without_state('deleted').reorder("contributions.created_at DESC").page(params[:page])
      else
        @contributions = apply_scopes(end_of_association_chain).without_state('deleted').reorder("contributions.created_at DESC")
      end
    elsif current_user.try(:channel) == channel && channel.present?
      if format == :html
        @contributions = apply_scopes(end_of_association_chain).without_state('deleted').joins(project: :channels).where(channels: {id: channel.id}).reorder("contributions.created_at DESC").page(params[:page])
      else
        @contributions = apply_scopes(end_of_association_chain).without_state('deleted').joins(project: :channels).where(channels: {id: channel.id}).reorder("contributions.created_at DESC")
      end
    end
  end

end
