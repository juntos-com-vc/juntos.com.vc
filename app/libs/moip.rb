class Moip
  attr_reader :token, :key
 
  def initialize(token = nil, key = nil)
    @token = token || get_token
    @key = key || get_key
  end
 
  def call
    authentication
  end

  def order(data)
    return @conn.post do |req|
      req.url '/v2/orders'
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
  end

  def payment(order, data)
    return @conn.post do |req|
      req.url '/v2/orders/' + order + '/payments'
      req.headers['Content-Type'] = 'application/json'
      req.body = data.to_json
    end
  end
 
  private
 
  def get_token
    ENV['MOIP_TOKEN']
  end
 
  def get_key
    ENV['MOIP_KEY']
  end
 
  def authentication
    url = ENV['MOIP_TEST'] ? 'https://sandbox.moip.com.br/' : 'https://api.moip.com.br/'
    puts "================== MOIP ================"
    puts url
    puts get_token
    puts get_key
    puts "================== FIM MOIP ================"
    @conn = Faraday.new(url: url)
    @conn.basic_auth(token, key)
  end
end