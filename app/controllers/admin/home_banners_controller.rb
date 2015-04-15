class Admin::HomeBannersController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  actions :index, :new, :create, :destroy, :edit, :update
  defaults resource_class: HomeBanner, collection_name: 'home_banners', instance_name: 'home_banner'

  def update
    update! { admin_home_banners_path }
  end
end
