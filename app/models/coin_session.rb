class CoinSession < ApplicationRecord
  belongs_to :coin
  belongs_to :next_coin, :class_name => 'Coin'
  belongs_to :previous_coin, :class_name => 'Coin'
end
