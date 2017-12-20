class BestHourStrategy

def initialize(attributes)
  @fastest_risers = attributes[:fastest_risers]
end

def call
  get_best_coin
end

private

def get_best_coin
  @fastest_risers[:best_last_hour].sort_by(:&['percent_change_1h'])
  @fastest_risers[:best_last_hour].sort_by {|coin| coin['percent_change_1h']}
end


end
