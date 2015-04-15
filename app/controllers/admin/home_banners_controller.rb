class Admin::HomeBannersController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  actions :index, :new, :create, :destroy
  defaults resource_class: HomeBanner, collection_name: 'home_banners', instance_name: 'home_banner'
end
