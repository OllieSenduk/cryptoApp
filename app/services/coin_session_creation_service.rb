class CoinSessionCreationService
  def initialize(attributes)
    @trade_process = attributes[:trade_process]
    @best_bet_outcome = attributes[:best_bet_outcome]
    @buy_in_euro = attributes[:buy_in_euro]
    @best_coin_symbol = @best_bet_outcome[0][0]
    @best_bet_amount_in_euro = @best_bet_outcome[0][1]["data"]["price_eur"].to_f
  end

  def call
    coin_exists
    create_new_coin_session
  end

  private

  def create_new_coin_session
    coin_session = CoinSession.new(
      trade_process: @trade_process,
      coin: @coin,
      amount_in_crypto: (@buy_in_euro / @best_bet_amount_in_euro)
      )
      coin_session.last_known_value = coin_session.amount_in_crypto * @best_bet_amount_in_euro
      SessionLog.create(
      coin_session: coin_session,
      change_log: "Coin: #{@coin.name}\nTrade process: #{@trade_process.id}\nTrade Strategy: #{@trade_process.strategy}\nAmount in crypto: #{coin_session.amount_in_crypto}\nStarting value in euro: #{coin_session.last_known_value}")
      coin_session.save
  end

  def coin_exists
    if Coin.find_by_symbol(@best_coin_symbol)
      @coin = Coin.find_by_symbol(@best_coin_symbol)
    else
      @coin = Coin.create(
        symbol: @best_coin_symbol,
        name: @best_bet_outcome[0][1]["data"]["name"],
        coin_market_id: @best_bet_outcome[0][1]["data"]["id"]
        )
    end
  end
end
