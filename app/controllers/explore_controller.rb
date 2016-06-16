class ExploreController < ApplicationController
  def index
    redirect_to root_url if channel.present?
    @categories = Category.with_visible_projects
  end
end
