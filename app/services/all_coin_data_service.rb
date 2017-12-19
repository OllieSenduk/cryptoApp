require 'open-uri'
require 'json'
class AllCoinDataService

  def initialize
  end

  def call
    searcher
  end


  private

  def searcher
    coin_data = JSON.parse(open("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=20").read)
    store_payload(coin_data)
    coin_data
  end

  def store_payload(coin_data)
    backtest = Backtest.new
    payload_extract = []
    coin_data.each do |data|
      payload_extract << { name: data['name'], symbol: data['symbol'], percent_change_1h: data['percent_change_1h'], percent_change_24h: data['percent_change_24h'], percent_change_7d: data['percent_change_7d'] }.to_json
    end
    payload_extract = payload_extract.to_json
    backtest.payload = payload_extract
    backtest.save!
  end

end
