require 'open-uri'
require 'json'
class SingleCoinDataService

  def initialize(attributes)
    @coin = attributes[:coin]
  end

  def call
    searcher
  end


  private

  def searcher
    JSON.parse(open("https://api.coinmarketcap.com/v1/ticker/#{@coin.coin_market_id}/?convert=EUR").read)
  end
end
