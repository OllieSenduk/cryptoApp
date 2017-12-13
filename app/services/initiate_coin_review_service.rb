class InitiateCoinReviewService
  def initialize
    @coindata = CoinDataService.new.call
  end

  def call
    best_bet
  end

  private

  def best_bet
    BestBetService.new(fastest_risers: fastest_risers).call
  end

  def fastest_risers
    FastestRisersService.new(coindata: @coindata).call
  end
end