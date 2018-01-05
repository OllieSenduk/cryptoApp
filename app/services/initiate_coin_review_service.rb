class InitiateCoinReviewService
  def initialize
    @coindata = AllCoinDataService.new.call
  end

  def call
    if TradeProcess.any?
      TradeProcess.all.each do |trade_process|
        check_rest_amount(trade_process)
        check_coin_session_status(trade_process)
      end
    else
      trade_process = InitiateTradeService.new.call
      check_coin_session_status(trade_process)
    end
  end

  private

  def check_coin_session_status(trade_process)
    if trade_process.coin_sessions.last.nil?
      CoinSessionCreationService.new(
        trade_process: trade_process,
        best_bet_outcome: trade_strategy(trade_process),
        buy_in_euro: ENV["INITIAL_VALUE"].to_i
        ).call
      trade_process.rest_amount.amount_of_transactions += 1
    elsif trade_process.coin_sessions.last.status == "running"
      DetermineChangeService.new(
        coin_session: trade_process.coin_sessions.last,
        best_bet_outcome: trade_strategy(trade_process)
        ).call
    elsif trade_process.coin_sessions.last.status == "pending"
      # This probably triggers when the transaction hasn't been finalized yet - Possibly stop
    else # It stopped
      # This probably triggers when the transaction hasn't been finalized yet - Possibly stop
    end
  end


  def check_rest_amount(trade_process)
    if trade_process.rest_amount.amount > ENV["INITIAL_VALUE"].to_i
      trade_process.rest_amount.amount -= 100
      trade_process.save
      trade_process = InitiateTradeService.new.call
      check_coin_session_status(trade_process)
    else
      trade_process = TradeProcess.last
    end
  end

  def trade_strategy(trade_process)
    case trade_process.strategy
    when "attribution"
      ::Strategies::AttributionStrategyService.new(fastest_risers: fastest_risers).call
    when "daily_fastest"
      ::Strategies::DailyFastestStrategyService.new(fastest_risers: fastest_risers).call
    when "weekly_fastest"
      ::Strategies::WeeklyFastestStrategyService.new(fastest_risers: fastest_risers).call
    else
      ::Strategies::AttributionStrategyService.new(fastest_risers: fastest_risers).call
    end
  end

  def fastest_risers
    FastestRisersService.new(coindata: @coindata).call
  end
end
