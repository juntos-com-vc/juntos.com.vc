class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    # add session information for tags
    session[:new_user_registration] = true;

    return_to = session[:return_to]
    session[:return_to] = nil

    return_to || sign_up_success_path
  end
end
