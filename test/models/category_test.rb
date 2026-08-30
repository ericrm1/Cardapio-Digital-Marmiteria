require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "requires a name" do
    restaurant = create_restaurant
    category = Category.new(restaurant: restaurant)
    assert_not category.valid?
    assert_includes category.errors.attribute_names, :name
  end

  test "cannot be destroyed while it still has products" do
    restaurant = create_restaurant
    category = create_category(restaurant)
    create_product(restaurant, category)

    assert_not category.destroy
    assert_includes category.errors.attribute_names, :base
    assert Category.exists?(category.id)
  end
end
