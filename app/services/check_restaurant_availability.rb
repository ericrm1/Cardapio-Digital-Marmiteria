class CheckRestaurantAvailability
  Result = Struct.new(:available, :reason, keyword_init: true) do
    def available?
      available
    end
  end

  def initialize(restaurant)
    @restaurant = restaurant
  end

  def call
    return Result.new(available: false, reason: :restaurant_inactive) unless @restaurant.active?
    return Result.new(available: false, reason: :not_accepting_orders) unless @restaurant.accepting_orders?
    return Result.new(available: false, reason: :closed) unless @restaurant.open_now?

    Result.new(available: true, reason: nil)
  end
end
