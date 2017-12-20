class TradeProcess < ApplicationRecord
  has_many :coin_sessions
  has_many :coins, through: :coin_sessions
  has_one :rest_amount

  before_create :decide_strategy

  private

  def decide_strategy
    if TradeProcess.last.nil?
      self.strategy = "compiled_best"
    elsif TradeProcess.last.strategy == "best_hour"
      self.strategy = "compiled_best"
    else
      self.strategy = "best_hour"
    end
  end



end
