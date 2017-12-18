class DetermineChangeService
  def initialize(attributes)
    @best_bet_outcome = attributes[:best_bet_outcome]
    @coin_session = attributes[:coin_session]
  end

  def call
    current_price_in_euro = SingleCoinDataService.new(coin: @coin_session.coin).call[0]["price_eur"].to_f
    @current_value_of_crypto_in_euro = @coin_session.amount_in_crypto * current_price_in_euro
    if coin_in_best?
      @coin_session.session_log.change_log << "\nCoin in best - DetermineChangeService"
      check_value
    else # SELL NOW
      @coin_session.session_log.change_log << "\nNot in best - DetermineChangeService"
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    end
  end

  private

  def coin_in_best?
    @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
  end

  def check_value
    if @current_value_of_crypto_in_euro >= @coin_session.last_known_value
      @coin_session.session_log.change_log << "\nValue went up - DetermineChangeService (#{@current_value_of_crypto_in_euro} => #{@coin_session.last_known_value})"
      # POTENTIALLY KEEP
      @coin_session.last_known_value = @current_value_of_crypto_in_euro
      @coin_session.save
    elsif @current_value_of_crypto_in_euro < @coin_session.last_known_value
      # SELL NOW
      @coin_session.session_log.change_log << "\nValue dropped - DetermineChangeService (#{@current_value_of_crypto_in_euro} => #{@coin_session.last_known_value})"
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    else
      @coin_session.session_log.change_log << "\nI dunno - DetermineChangeService"
      # I dunno
    end
  end
end
