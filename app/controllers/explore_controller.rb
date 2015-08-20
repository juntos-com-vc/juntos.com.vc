class ExploreController < ApplicationController
  def index
    redirect_to root_url if channel.present?
    @categories = Category.with_projects.order(:name_pt).all
  end
end
