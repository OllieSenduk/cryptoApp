class TradeProcessesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @trade_process = TradeProcess.find(params[:id])
  end
end