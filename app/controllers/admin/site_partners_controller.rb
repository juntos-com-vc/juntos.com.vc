class Admin::SitePartnersController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  defaults resource_class: SitePartner, collection_name: 'site_partners', instance_name: 'site_partner'

  def create
    create! { admin_site_partners_path }
  end

  def update
    update! { admin_site_partners_path }
  end

end
