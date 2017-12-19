class TradeProcess < ApplicationRecord
  has_many :coin_sessions
  has_many :coins, through: :coin_sessions
  has_one :rest_amount

  after_create :decide_strategy

  private

  def decide_strategy
    if TradeProcess.last.strategy != "best_bet" || TradeProcess.last.nil?
      self.update(strategy: "best_bet")
    else TradeProcess.last.strategy == "best_bet"
      self.update(strategy: "best_bet")
    end
  end


end
