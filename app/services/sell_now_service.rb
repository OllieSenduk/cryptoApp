class SellNowService
  def initialize(attributes)
    @coin_session = attributes[:coin_session]
    @best_bet_outcome = attributes[:best_bet_outcome]
    @current_value_of_crypto_in_euro = attributes[:current_value_of_crypto_in_euro]
  end

  def call
    update_coin_session_status
    change_rest_amount
    create_next_session
  end

  private

  def change_rest_amount
    rest_amount = @coin_session.trade_process.rest_amount
    if @current_value_of_crypto_in_euro - ENV["INITIAL_VALUE"].to_i > 0
      rest_amount.amount += @current_value_of_crypto_in_euro - ENV["INITIAL_VALUE"].to_i
    end
    rest_amount.amount_of_transactions += 1
    rest_amount.save
  end

  def update_coin_session_status
    @coin_session.status = "stopped"
    @coin_session.last_known_value = @current_value_of_crypto_in_euro
    @coin_session.save
  end

  def create_next_session
    CoinSessionCreationService.new(
      trade_process: @coin_session.trade_process,
      best_bet_outcome: @best_bet_outcome,
      buy_in_euro: (@current_value_of_crypto_in_euro > ENV["INITIAL_VALUE"].to_i ? ENV["INITIAL_VALUE"].to_i : @current_value_of_crypto_in_euro)
      ).call
  end
end

