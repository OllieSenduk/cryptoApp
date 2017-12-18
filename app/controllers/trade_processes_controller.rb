class TradeProcessesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @trade_process = TradeProcess.find(params[:id])
    @coins = Coin.order("coin_sessions_count ASC").paginate(:page => params[:page], :per_page => 15)
    @coin_sessions = @trade_process.coin_sessions.order('updated_at DESC').paginate(:page => params[:page], :per_page => 4)
  end
end