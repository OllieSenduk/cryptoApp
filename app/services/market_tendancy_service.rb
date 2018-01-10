class MarketTendancyService

  def initialize
  end

  def call
    coin_data = JSON.parse(open("https://api.coinmarketcap.com/v1/ticker/?convert=EUR&limit=100").read)
    check_tendancy(coin_data)["overall_value"] > 10 ? true : false
  end

  private

  def check_tendancy(coin_data)
    tendancy_ticker = {"overall_value" => 0, "data" => []}
    coin_data.each do |coin|
      if (coin['percent_change_1h'].to_f < 0) && (coin['percent_change_24h'].to_f < 0)
        tendancy_ticker["overall_value"] += -4
        tendancy_ticker["data"] << {"name" => coin["name"], "value" => -4, "symbol" => coin["symbol"], "price_up" => coin['percent_change_1h'].to_f}
      elsif (coin['percent_change_1h'].to_f < 0)
        tendancy_ticker["overall_value"] += -3
        tendancy_ticker["data"] << {"name" => coin["name"], "value" => -3, "symbol" => coin["symbol"], "price_up" => coin['percent_change_1h'].to_f}
      else
        tendancy_ticker["overall_value"] += 4
        tendancy_ticker["data"] << {"name" => coin["name"], "value" => 4, "symbol" => coin["symbol"], "price_up" => coin['percent_change_1h'].to_f}
      end
    end
    tendancy_ticker
  end
end
