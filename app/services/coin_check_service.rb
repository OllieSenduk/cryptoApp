require 'open-uri'
require 'json'
class CoinCheckService

  def initialize
  end

  def call
  end

  def searcher
    api_url = "https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=10"
    json_payload = open(api_url)
    payload = JSON.parse(json_payload.read)
    puts payload
  end

  private
end
