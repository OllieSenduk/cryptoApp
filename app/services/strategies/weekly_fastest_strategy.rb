class Strategies::WeeklyFastestStrategyService
  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    @fastest_risers[:best_last_week].first(3)
  end

end