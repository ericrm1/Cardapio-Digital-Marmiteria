require "test_helper"

class AddonTest < ActiveSupport::TestCase
  test "requires name and non-negative price" do
    restaurant = create_restaurant
    addon = Addon.new(restaurant: restaurant, price: -1)
    assert_not addon.valid?
    assert_includes addon.errors.attribute_names, :name
    assert_includes addon.errors[:price], "deve ser maior ou igual a 0"
  end
end
