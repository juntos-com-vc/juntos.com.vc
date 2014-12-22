class PressesController < ApplicationController
  inherit_resources
  actions :index

  respond_to :html

  protected

  def permitted_params
    params.permit(policy(resource).permitted_attributes)
  end
end
