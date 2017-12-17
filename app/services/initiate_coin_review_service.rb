class InitiateCoinReviewService
  def initialize
    @coindata = AllCoinDataService.new.call
    @best_bet_outcome = best_bet
  end

  def call
    if TradeProcess.any?
      TradeProcess.all.each do |trade_process|
        check_rest_amount(trade_process)
        check_coin_session_status(trade_process)
      end
    else
      @trade_process = InitiateTradeService.new.call
    end
  end

  private

  def check_coin_session_status(trade_process)
    if @trade_process.coin_sessions.last.nil?
      CoinSessionCreationService.new(
        trade_process: @trade_process, 
        best_bet_outcome: @best_bet_outcome, 
        buy_in_euro: ENV["INITIAL_VALUE"].to_i
        ).call
    elsif @trade_process.coin_sessions.last.status == "running"
      DetermineChangeService.new(
        coin_session: @trade_process.coin_sessions.last, 
        best_bet_outcome: @best_bet_outcome
        ).call
    elsif @trade_process.coin_sessions.last.status == "pending"
      # This probably triggers when the transaction hasn't been finalized yet - Possibly stop
    else # It stopped
      # This probably triggers when the transaction hasn't been finalized yet - Possibly stop
    end
  end


  def check_rest_amount(trade_process)
    if trade_process.rest_amount.amount > ENV["INITIAL_VALUE"].to_i
      trade_process.rest_amount.amount -= 100
      trade_process.save 
      @trade_process = InitiateTradeService.new.call
    else
      @trade_process = TradeProcess.last
    end
  end

  def best_bet
    BestBetService.new(fastest_risers: fastest_risers).call
  end

  def fastest_risers
    FastestRisersService.new(coindata: @coindata).call
  end
end