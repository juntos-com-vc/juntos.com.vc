class Admin::PagesController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources
  actions :index, :edit, :update
  defaults resource_class: Page, collection_name: 'pages', instance_name: 'page'

  def update
    update! { admin_pages_path }
  end

end
