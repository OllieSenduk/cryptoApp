class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @amount_of_trade_processes = TradeProcess.count
    @trade_processes = TradeProcess.all.paginate(:page => params[:page], :per_page => 5)
    @coins = Coin.order("coin_sessions_count DESC").paginate(:page => params[:page], :per_page => 15)
  end
end
