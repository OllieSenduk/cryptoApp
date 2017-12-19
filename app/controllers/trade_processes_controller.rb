class TradeProcessesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @trade_process = TradeProcess.find(params[:id])
    @coins = Coin.order("coin_sessions_count ASC")
    @coin_sessions = @trade_process.coin_sessions.order('updated_at DESC').paginate(page: params[:log_page], per_page: 4)
    set_timeline
  end

  private

  def set_timeline
    timeline_raw = @trade_process.coin_sessions.where(updated_at: (Time.now - 1.hour)..Time.now).map { |coin_session| [coin_session.coin.symbol, coin_session.created_at.strftime("%Y-%m-%d %H:%M"), coin_session.updated_at.strftime("%Y-%m-%d %H:%M")]}
    @timeline = timeline_raw - timeline_raw.select { |item| item[1] == item[2] }
  end
end