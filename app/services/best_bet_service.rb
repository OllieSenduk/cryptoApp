class BestBetService
  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    compile_scores.first(10)
    # best_three = compile_scores.first(1)
    # best_three.each do |coin_symbol, evaluation|
    #   included_in = compose_inclusion_check(coin_symbol)
    #   puts "#{coin_symbol} at #{evaluation} points"
    #   included_in.each { |classification| puts "included in #{classification.to_s}" }
    # end
  end

  private

  def compile_scores
    result = {}
    @fastest_risers.each do |classification, collection|
      if classification == :best_last_hour
        add_to_hash(collection, 2, result)
      elsif classification == :best_last_24h
        add_to_hash(collection, 1.5, result)
      else
        add_to_hash(collection, 1, result)
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

  def compose_inclusion_check(coin_symbol)
    result = []
    @fastest_risers.each do |classification, collection|
      result << classification if coin_inclusion?(collection, coin_symbol)
    end
    result
  end

  def coin_inclusion?(collection, coin_symbol)
    collection.any? { |coin| coin["symbol"] == coin_symbol }
  end

end
