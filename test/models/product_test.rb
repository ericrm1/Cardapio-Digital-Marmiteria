require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @restaurant = create_restaurant
    @category = create_category(@restaurant)
  end

  test "requires name and category" do
    product = Product.new(restaurant: @restaurant, price: 10)
    assert_not product.valid?
    assert_includes product.errors.attribute_names, :name
    assert_includes product.errors.attribute_names, :category
  end

  test "price must be present and non-negative" do
    product = Product.new(restaurant: @restaurant, category: @category, name: "X", price: -1)
    assert_not product.valid?
    assert_includes product.errors[:price], "deve ser maior ou igual a 0"
  end

  test "rejects a category belonging to another restaurant" do
    other_restaurant = create_restaurant
    other_category = create_category(other_restaurant)

    product = Product.new(restaurant: @restaurant, category: other_category, name: "X", price: 10)

    assert_not product.valid?
    assert_includes product.errors.attribute_names, :category
  end
end
