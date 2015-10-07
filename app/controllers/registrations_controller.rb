class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    # add session information for tags
    session[:new_user_registration] = true;

    # normal after_sign_up_path_for
    return_to = session[:return_to]
    if return_to and return_to.include?('contributions')
      return_to = session[:return_to]
      session[:return_to] = nil
      return return_to
    else
      return "/#{I18n.locale}/sign_up_success"
    end
  end
end
