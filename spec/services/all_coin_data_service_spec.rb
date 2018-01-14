require 'rails_helper'
require 'json'
require 'open-uri'

describe AllCoinDataService do

  context 'fetches data' do
    let(:cb_response) { load_fixture('/coin_market_ticker_20.json') }

    it 'creates a backtest object' do
      stub_request(:get, "https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=20").to_return(body: cb_response, status: 200)
      AllCoinDataService.new.call

      expect(Backtest.count).to eq 1
      expect(Backtest.first.payload).to be_kind_of(String)
    end
  end

 context 'Handles errors' do

    it 'handles 404' do
      stub_request(:get, "https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=20").to_return(body: "Page not found", status: 404)

      expect(AllCoinDataService.new.call).to eq 'Page not found'
      expect(Backtest.count).to eq 0
      # TODO SEND US A SLACKER NOTIFICATION
    end

    it 'lower level errors' do
      stub_request(:get, "https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=20").to_raise Errno::ENOENT
      expect(AllCoinDataService.new.call).to eq 'Another error occured, most probebly a timeout'
      expect(Backtest.count).to eq 0
    end
 end

end
