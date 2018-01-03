class DetermineChangeService
  def initialize(attributes)
    @best_bet_outcome = attributes[:best_bet_outcome]
    @coin_session = attributes[:coin_session]
    @session_log = @coin_session.session_log
  end

  def call
    current_price_in_euro = SingleCoinDataService.new(coin: @coin_session.coin).call[0]["price_eur"].to_f
    @current_value_of_crypto_in_euro = @coin_session.amount_in_crypto * current_price_in_euro
    if coin_in_best?
      @session_log.change_log << "\nCoin in best - DetermineChangeService | #{Time.now.in_time_zone("Amsterdam").strftime("%H:%M on %A, %e %B %Y")}"
      @session_log.save
      check_value
    else # SELL NOW
      @session_log.change_log << "\nNot in best - DetermineChangeService | #{Time.now.in_time_zone("Amsterdam").strftime("%H:%M on %A, %e %B %Y")}"
      @session_log.save
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    end
  end

  private

  def coin_in_best?
    @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
  end

  def check_value
    if @current_value_of_crypto_in_euro >= @coin_session.last_known_value
      went_up
    elsif @current_value_of_crypto_in_euro < @coin_session.last_known_value
     went_down
   else
    @session_log.change_log << "\nI dunno - DetermineChangeService"
    @session_log.save
      # I dunno
    end
  end

  def went_up
    if @current_value_of_crypto_in_euro == @coin_session.last_known_value
      @session_log.change_log << "\nValue unchanged - DetermineChangeService (#{@coin_session.last_known_value.round(3)} => #{@current_value_of_crypto_in_euro.round(3)})"
    else
      @session_log.change_log << "\nValue went up - DetermineChangeService (#{@coin_session.last_known_value.round(3)} => #{@current_value_of_crypto_in_euro.round(3)})"
    end
    @session_log.save
    # POTENTIALLY KEEP
    @coin_session.last_known_value = @current_value_of_crypto_in_euro
    @coin_session.save
  end

  def went_down
    # SELL NOW
    @session_log.change_log << "\nValue dropped - DetermineChangeService (#{@coin_session.last_known_value.round(3)} => #{@current_value_of_crypto_in_euro.round(3)})"
    @session_log.save
    if @best_bet_outcome[0][0] == @coin_session.coin.symbol
      @session_log.change_log << "\nBest coin still current coin - DetermineChangeService (#{@coin_session.last_known_value.round(3)} => #{@current_value_of_crypto_in_euro.round(3)})"
      @session_log.save
    elsif @coin_session.trade_process.strategy == "daily_fastest"
      @session_log.change_log << "\nKeeping daily fastest"
      @session_log.save
    else
      SellNowService.new(best_bet_outcome: @best_bet_outcome, coin_session: @coin_session, current_value_of_crypto_in_euro: @current_value_of_crypto_in_euro).call
    end
  end
end
