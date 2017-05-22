class RegistrationsController < Devise::RegistrationsController
  protected
  before_filter :verify, :only => [:new]

  def verify
  	if request.protocol == 'http://' && ENV['ENVIRONMENT'] == 'production'
  		redirect_to base_url = "https://secure.juntos.com.vc/#{params[:locale]}/sign_up"
  	end
  end

  def after_sign_up_path_for(resource)
    # add session information for tags
    session[:new_user_registration] = true;

    return_to = session[:return_to]
    session[:return_to] = nil

    return_to || sign_up_success_path
  end
end
