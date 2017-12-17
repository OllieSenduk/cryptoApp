class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @amount_of_trade_processes = TradeProcess.count
    @trade_processes = TradeProcess.all
    @coins = Coin.order("coin_sessions_count ASC").paginate(:page => params[:page], :per_page => 15)
  end
end
