class ProjectPartnersController < ApplicationController
  after_filter :verify_authorized
  inherit_resources

  respond_to :html

  protected

  def permitted_params
    params.permit(policy(resource).permitted_attributes)
  end
end
