class InitiateTradeService
  def initialize
  end

  def call
    trade_process = TradeProcess.create
    RestAmount.create(trade_process: trade_process, amount: 0.0, amount_of_transactions: 0)
    return trade_process
  end
end
