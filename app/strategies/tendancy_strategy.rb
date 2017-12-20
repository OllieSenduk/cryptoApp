class TendancyStrategy

  def initialize(attributes)
    @fastest_risers = attributes[:fastest_risers]
  end

  def call
    check_tendancy
  end

  private

  def check_tendancy
    puts @fastest_risers
  end
end
