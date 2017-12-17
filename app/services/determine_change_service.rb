class DetermineChangeService
  def initialize(attributes)
    @best_bet_outcome = attributes[:best_bet_outcome]
    @coin_session = attributes[:coin_session]
  end

  def call
    current_price_in_euro = SingleCoinDataService.new(coin: @coin_session.coin).call[0]["price_eur"].to_f
    @current_value_of_crypto_in_euro = @coin_session.amount_in_crypto * current_price_in_euro
    if coin_in_best?
      puts "Coin in best - DetermineChangeService"
      check_value
    else # SELL NOW
      puts "Not in best - DetermineChangeService"
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    end
  end

  private

  def coin_in_best?
    @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
  end

  def check_value
    if @current_value_of_crypto_in_euro >= @coin_session.last_known_value
       puts "Value went up - DetermineChangeService"
      # POTENTIALLY KEEP
      @coin_session.last_known_value = @current_value_of_crypto_in_euro
      @coin_session.save
    elsif @current_value_of_crypto_in_euro < @coin_session.last_known_value
      # SELL NOW
      puts "Value dropped - DetermineChangeService"
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    else
      puts "I dunno - DetermineChangeService"
      # I dunno
    end
  end
end
