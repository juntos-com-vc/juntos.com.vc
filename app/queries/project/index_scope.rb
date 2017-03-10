class Project::IndexScope
  LIMIT_NEAR_PROJECT   = 3
  LIMIT_RECENT_PROJECT = 6

  attr_reader :projects, :current_user

  def initialize(projects, current_user)
    @projects     = projects
    @current_user = current_user || User.new
  end

  def recommends
    @recommends ||= projects.recommended_for_home.includes(:project_total)
  end

  def projects_near
    @projects_near ||= projects
                        .random_near_online_with_limit(current_user.address_state, LIMIT_NEAR_PROJECT)
                        .includes(:project_total) if current_user.persisted?
  end

  def expiring
    @expiring ||= projects.expiring_for_home.includes(:project_total)
  end

  def recent
    @recent ||= projects
                 .online_non_recommended_with_limit(LIMIT_RECENT_PROJECT)
                 .includes(:project_total)
  end

  def featured_partners
    @featured_partners ||= SitePartner.featured
  end

  def regular_partners
    @regular_partners ||= SitePartner.regular
  end

  def site_partners
    @site_partners ||= featured_partners + regular_partners
  end

  def channels
    @channels ||= visible_channels
  end

  def banners
    @banners ||= HomeBanner.asc_order_by_numeric_order
  end

  private

  def visible_channels
    if current_user.admin?
      Channel.all
    else
      Channel.visible
    end
  end
end
