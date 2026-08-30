require "test_helper"

class CheckRestaurantAvailabilityTest < ActiveSupport::TestCase
  test "unavailable when restaurant is inactive" do
    restaurant = create_restaurant(active: false)
    result = CheckRestaurantAvailability.new(restaurant).call

    assert_not result.available?
    assert_equal :restaurant_inactive, result.reason
  end

  test "unavailable when not accepting orders" do
    restaurant = create_restaurant(accepting_orders: false)
    open_all_hours_for(restaurant)
    result = CheckRestaurantAvailability.new(restaurant).call

    assert_not result.available?
    assert_equal :not_accepting_orders, result.reason
  end

  test "unavailable when outside business hours" do
    restaurant = create_restaurant
    result = CheckRestaurantAvailability.new(restaurant).call

    assert_not result.available?
    assert_equal :closed, result.reason
  end

  test "available when active, accepting orders and within business hours" do
    restaurant = create_restaurant
    open_all_hours_for(restaurant)
    result = CheckRestaurantAvailability.new(restaurant).call

    assert result.available?
    assert_nil result.reason
  end
end
