class DetermineChangeService
  def initialize(attributes)
    @best_bet_outcome = attributes[:best_bet_outcome]
    @coin_session = attributes[:coin_session]
  end

  def call
    if coin_in_best?

      current_price_in_euro = SingleCoinDataService.new(coin: @coin_session.coin).call[0]["price_eur"].to_f
      current_value_of_crypto_in_euro = @coin_session.amount_in_crypto * current_price_in_euro


      if current_value_of_crypto_in_euro >= @coin_session.last_known_value
        # POTENTIALLY KEEP
        @coin_session.last_known_value = current_value_of_crypto_in_euro
        @coin_session.save
      elsif current_value_of_crypto_in_euro < @coin_session.last_known_value
        # SELL NOW
        SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session).call
      else
        # I dunno
      end

    else # SELL NOW
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session).call
    end
  end

  private

  def coin_in_best?
    @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
  end
end
