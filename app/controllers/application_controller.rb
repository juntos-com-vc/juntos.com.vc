# coding: utf-8
class ApplicationController < ActionController::Base
  include Concerns::ExceptionHandler
  include Concerns::MenuHandler
  include Concerns::SocialHelpersHandler
  include Concerns::AnalyticsHelpersHandler
  include Pundit

  layout :use_catarse_boostrap
  protect_from_forgery

  before_filter :get_login_and_register_url
  before_filter :redirect_user_back_after_login, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :channel, :namespace, :referal_link
  helper_method :devise_current_user

  before_filter :set_locale

  before_action :referal_it!

  def channel
    channel = Channel.find_by_permalink(request.subdomain.to_s)
    channel.decorator if channel
  end

  def referal_link
    session[:referal_link]
  end

  def ajax_request?
    request.xhr? == 0
  end

  def current_user
    UserDecorator.decorate(super) unless super.nil?
  end

  private
  def referal_it!
    session[:referal_link] = params[:ref] if params[:ref].present?
  end

  def detect_old_browsers
    return redirect_to page_path("bad_browser") if (!browser.modern? || browser.ie9?) && controller_name != 'pages'
  end

  def namespace
    names = self.class.to_s.split('::')
    return "null" if names.length < 2
    names[0..(names.length-2)].map(&:downcase).join('_')
  end

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
      current_user.try(:change_locale, params[:locale])
    elsif request.method == "GET"
      new_locale = current_user.try(:locale) || I18n.default_locale
      redirect_to url_for(params.merge(locale: new_locale, only_path: true))
    end
  end

  def use_catarse_boostrap
    devise_controller? ? 'juntos_bootstrap' : 'application'
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def after_sign_in_path_for(resource_or_scope)
    return_to = session[:return_to]
    session[:return_to] = nil
    (return_to || root_path)
  end

  def get_login_and_register_url
    base_url = "https://secure.juntos.com.vc"
    login_address = "/#{params[:locale]}/login"
    register_address = "/#{params[:locale]}/sign_up"
    if ENV['ENVIRONMENT'] == 'development' || ENV['ENVIRONMENT'] == 'staging'
      base_url = ""
    end
    @url_login = base_url + login_address
    @url_register = base_url + register_address
  end

  def redirect_user_back_after_login
    if request.env['REQUEST_URI'].present? && !ajax_request?
      # session[:return_to] = request.env['REQUEST_URI']
      session[:return_to] = request.original_url
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:access_type, :name, :email, :password, :newsletter)
    end
  end

  def set_country_payment_engine
    begin
      session[:payment_country] ||= GeoIp.geolocation(request.remote_ip, precision: :country)[:country_code]
    rescue
      # There has been a problem with GeoIp that is timing out every request.
      # Most likely their API is down for some reason.
      # I'm replacing it's code for now.
      # Look into replacing the API as soon as possible
      session[:payment_country] = 'BR'
      puts "error loading Geolocation"
    end
  end
end
