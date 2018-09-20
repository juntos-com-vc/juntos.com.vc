class Moip
  attr_reader :token, :key
 
  def initialize(token = nil, key = nil)
    @token = token || get_token
    @key = key || get_key
  end
 
  def call
    authentication
  end
 
  private
 
  def get_token
    ENV['MOIP_TOKEN']
  end
 
  def get_key
    ENV['MOIP_KEY']
  end
 
  def credentials
    Rails.application.credentials[Rails.env.to_sym][:moip]
  end
 
  def authentication
    Moip2::Api.new(moip_client)
  end
 
  def moip_client
    moip_env = ENV['MOIP_TEST'] ? :sandbox : :production
    Moip2::Client.new(moip_env, moip_auth)
  end
 
  def moip_auth
    auth = Moip2::Auth::Basic.new(token, key)
  end
end