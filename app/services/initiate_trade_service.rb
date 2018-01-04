class InitiateTradeService
  def initialize
    @strategies =  ["attribution", "daily_fastest", "weekly_fastest"]
  end

  def call
    trade_process = TradeProcess.create(
      strategy: determine_strategy
      )
    RestAmount.create(
      trade_process: trade_process, 
      amount: 0.0, 
      amount_of_transactions: 0
      )
    return trade_process
  end

  private

  def determine_strategy
    last_trade_process = TradeProcess.last
    if last_trade_process.nil?
      return @strategies.first
    else
      determine_last_strategy(last_trade_process)
    end
  end

  def determine_last_strategy(last_trade_process)
    position = @strategies.find_index(last_trade_process.strategy)
    if (position + 1) >= @strategies.length
      return @strategies.first
    else
      return @strategies[position + 1]
    end
  end
end
