class CoinSession < ApplicationRecord
  belongs_to :coin, counter_cache: true
  belongs_to :trade_process
  belongs_to :next_coin, :class_name => 'Coin', optional: true
  belongs_to :previous_coin, :class_name => 'Coin', optional: true
end
