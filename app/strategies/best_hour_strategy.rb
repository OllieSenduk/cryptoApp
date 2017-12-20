class BestHourStrategy

  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    compile_scores.first(1)
  end

  private

  def compile_scores
    result = {}
    @fastest_risers.each do |classification, collection|
      if classification == :best_last_hour
        coin = collection.sort_by {|coin| coin["percent_change_1h"]}.reverse.first
        result[coin["symbol"]] = {
          "points" => 10,
          "data" => coin
        }
      end
    end
    result
  end
end
