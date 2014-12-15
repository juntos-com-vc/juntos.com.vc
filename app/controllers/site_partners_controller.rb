class SitePartnersController < ApplicationController
  inherit_resources
  actions :index
  respond_to :html, :json

end
