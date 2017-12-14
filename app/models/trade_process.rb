class TradeProcess < ApplicationRecord
  has_many :coin_sessions
  has_one :rest_amount
end
