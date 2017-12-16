class FastestRisersService
  def initialize(attributes)
    @coindata = attributes[:coindata]
  end

  def call
     {
      best_last_hour: sort_by_change_1h.first(10),
      best_last_24h: sort_by_change_24h.first(10),
      best_last_week: sort_by_change_7d.first(10)
    }
  end

  private

  def sort_by_change_1h
    @coindata.sort_by { |coin| coin["percent_change_1h"].to_i }.reverse
  end

  def sort_by_change_24h
    @coindata.sort_by { |coin| coin["percent_change_24h"].to_i }.reverse
  end

  def sort_by_change_7d
    @coindata.sort_by { |coin| coin["percent_change_7d"].to_i }.reverse
  end
end