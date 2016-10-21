class Admin::UsersController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  has_scope :by_id, :by_name, :by_email, :by_payer_email, :by_contribution_key, only: :index
  has_scope :has_credits, type: :boolean, only: :index
  has_scope :only_organizations, type: :boolean, only: :index

  def index
    respond_to do |format|
      format.html { collection }
      format.csv do
        self.response_body = Enumerator.new do |y|
          collection(false).copy_to do |line|
            y << line
          end
        end
      end
    end
  end

  protected
  def collection(with_pagination = true)
    if with_pagination
      @users ||= apply_scopes(end_of_association_chain).order_by(params[:order_by]).includes(:user_total).page(params[:page])
    else
      apply_scopes(end_of_association_chain).order_by(params[:order_by]).includes(:user_total)
    end
  end
end

