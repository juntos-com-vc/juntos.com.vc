class Admin::PressesController < Admin::BaseController
  layout 'juntos_bootstrap'
  inherit_resources

  def create
    create! { admin_presses_path }
  end

  def update
    update! { admin_presses_path }
  end

end
