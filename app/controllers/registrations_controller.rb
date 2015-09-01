class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    "/#{I18n.locale}/sign_up_success"
  end
end
