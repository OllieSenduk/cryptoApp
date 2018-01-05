class TradeProcessesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]

  def show
    @trade_process = TradeProcess.find(params[:id])
    @coins = Coin.order("coin_sessions_count ASC")
    @coin_sessions = @trade_process.coin_sessions.order('updated_at DESC').paginate(page: params[:log_page], per_page: 4)
    set_timeline
  end

  def index
    @amount_of_trade_processes = TradeProcess.count
    @trade_processes = TradeProcess.all.paginate(page: params[:process_page], per_page: 5)
    @coins = Coin.order("coin_sessions_count DESC").paginate(page: params[:coin_page], per_page: 5)
  end

  private

  def set_timeline
    timeline_raw = @trade_process.coin_sessions.where(updated_at: (Time.now - 24.hours)..Time.now).map { |coin_session| [coin_session.coin.symbol, coin_session.created_at.strftime("%Y-%m-%d %H:%M"), coin_session.updated_at.strftime("%Y-%m-%d %H:%M")]}
    @timeline = timeline_raw - timeline_raw.select { |item| item[1] == item[2] }
  end
end