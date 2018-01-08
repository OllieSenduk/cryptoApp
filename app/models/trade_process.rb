class TradeProcess < ApplicationRecord
  has_many :coin_sessions, dependent: :destroy
  has_many :coins, through: :coin_sessions, dependent: :destroy
  has_one :rest_amount, dependent: :destroy

end
