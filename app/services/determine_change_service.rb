class DetermineChangeService
  def initialize(attributes)
    @best_bet_outcome = attributes[:best_bet_outcome]
    @coin_session = attributes[:coin_session]
  end

  def call
    if coin_in_best?
      current_crypto_from_best_bet = @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
      unless current_crypto_from_best_bet.nil?
        current_price_in_euro = current_crypto_from_best_bet[0][1]["data"]["price_eur"].to_f
        current_value_of_crypto_in_euro = @coin_session.amount_in_crypto * current_price_in_euro
      end
      if current_crypto_from_best_bet.nil?
        # SELL NOW
        @coin_session.status = "stopped"
        @coin_session.save
        CoinSessionCreationService.new(
          trade_process: @coin_session.trade_process,
          best_bet_outcome: @best_bet_outcome,
          value_in_euro: current_value_of_crypto_in_euro,
          buy_in_euro: ENV["INITIAL_VALUE"].to_i
          ).call
        rest_amount = @coin_session.trade_process.rest_amount
        rest_amount.amount += current_value_of_crypto_in_euro - ENV["INITIAL_VALUE"].to_i
        rest_amount.amount_of_transactions += 1
        rest_amount.save
      elsif current_value_of_crypto_in_euro >= @coin_session.last_known_value
        # POTENTIALLY KEEP
        @coin_session.last_known_value = current_value_of_crypto_in_euro
        @coin_session.save
      elsif current_value_of_crypto_in_euro < @coin_session.last_known_value
        # SELL NOW
        @coin_session.status = "stopped"
        @coin_session.last_known_value = current_value_of_crypto_in_euro
        @coin_session.save
        CoinSessionCreationService.new(
          trade_process: @coin_session.trade_process,
          best_bet_outcome: @best_bet_outcome,
          value_in_euro: current_value_of_crypto_in_euro,
          buy_in_euro: ENV["INITIAL_VALUE"].to_i
          ).call
        rest_amount = @coin_session.trade_process.rest_amount
        rest_amount.amount += current_value_of_crypto_in_euro - ENV["INITIAL_VALUE"].to_i
        rest_amount.amount_of_transactions += 1
        rest_amount.save
      else
        # I dunno
      end
    else # SELL NOW
      @coin_session.status = "stopped"
      @coin_session.save
      CoinSessionCreationService.new(
        trade_process: @coin_session.trade_process,
        best_bet_outcome: @best_bet_outcome,
        value_in_euro: current_value_of_crypto_in_euro,
        buy_in_euro: ENV["INITIAL_VALUE"].to_i
        ).call
      rest_amount = @coin_session.trade_process.rest_amount
      rest_amount.amount += current_value_of_crypto_in_euro - ENV["INITIAL_VALUE"].to_i
      rest_amount.amount_of_transactions += 1
      rest_amount.save
    end
  end

  private

  def coin_in_best?
    @best_bet_outcome.select {|e| e[0] == @coin_session.coin.symbol }
  end
end
