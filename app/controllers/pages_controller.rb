class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @trade_process = TradeProcess.last
    @coins = Coin.order("coin_sessions_count ASC").paginate(:page => params[:page], :per_page => 15)
  end
end
