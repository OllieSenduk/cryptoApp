require 'open-uri'
require 'json'
class CoinDataService

  def initialize
  end

  def call
    searcher
  end


  private

  def searcher
    JSON.parse(open("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=20").read)
  end
end
