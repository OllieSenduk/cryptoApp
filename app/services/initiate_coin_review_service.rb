class InitiateCoinReviewService
  def initialize
    @coindata = CoinDataService.new.call
  end

  def call
    # Step 1
    if TradeProcess.any?
      trade_process = TradeProcess.first
    else
      trade_process = InitiateTradeService.new.call
    end

    # Step 2
    best_bet_outcome = best_bet


    # Step 3
    
    if trade_process.coin_sessions.last.nil?
      CoinSessionCreationService.new(
        trade_process: trade_process, 
        best_bet_outcome: best_bet_outcome, 
        buy_in_euro: ENV["INITIAL_VALUE"]
        ).call
    elsif trade_process.coin_sessions.last.status == "running"
      DetermineChangeService.new(
        coin_session: trade_process.coin_sessions.last, 
        best_bet_outcome: best_bet_outcome
        ).call
    elsif trade_process.coin_sessions.last.status == "pending"

    else # It stopped
      # This probably triggers when the transaction hasn't been finalized yet
    end


  end

  private

  def best_bet
    BestBetService.new(fastest_risers: fastest_risers).call
  end

  def fastest_risers
    FastestRisersService.new(coindata: @coindata).call
  end
end