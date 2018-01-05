class Strategies::DailyFastestStrategyService
  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    compile_scores.first(3)
  end

  private

  def compile_scores
    result = {}
    @fastest_risers.each do |classification, collection|
      if classification == :best_last_24h
        add_to_hash(collection, 2, result)
      end
    end
    sort_by_best_result(result)
  end

  def add_to_hash(collection, modifier, result)
    collection.each do |coin|
      if result.has_key?(coin["symbol"])
        result[coin["symbol"]]["points"] += modifier
      else
        result[coin["symbol"]] = {
          "points" => modifier,
          "data" => coin
        }
      end
    end
  end

  def sort_by_best_result(result)
    result.sort_by {|item| item.last["points"] }.reverse
  end

end