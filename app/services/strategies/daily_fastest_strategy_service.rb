class Strategies::DailyFastestStrategyService
  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    @fastest_risers[:best_last_24h].first(3)
  end

end