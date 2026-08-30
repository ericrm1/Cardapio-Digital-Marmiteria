require "test_helper"

class CalculateOrderTotalTest < ActiveSupport::TestCase
  setup do
    @restaurant = create_restaurant
    @category = create_category(@restaurant)
    @product = create_product(@restaurant, @category, price: 25.0)
    @addon = create_addon(@restaurant, price: 3.0)
    ProductAddon.create!(product: @product, addon: @addon)
  end

  test "computes (product + addons) x quantity from database prices" do
    cart_item = Cart::Item.new(id: "1", product_id: @product.id, quantity: 2, observation: "Sem cebola", addon_ids: [ @addon.id ])

    result = CalculateOrderTotal.new(@restaurant, [ cart_item ]).call

    assert_equal 1, result.line_items.size
    assert_equal 56.0, result.total.to_f
    assert_equal "Sem cebola", result.line_items.first.observation
  end

  test "ignores a price sent by the client and always recalculates from the database" do
    tampered_cart_item = Cart::Item.new(id: "1", product_id: @product.id, quantity: 1, addon_ids: [])

    result = CalculateOrderTotal.new(@restaurant, [ tampered_cart_item ]).call

    assert_equal @product.price.to_f, result.total.to_f
  end

  test "ignores a product that does not belong to the restaurant" do
    other_restaurant = create_restaurant
    other_category = create_category(other_restaurant)
    foreign_product = create_product(other_restaurant, other_category)

    cart_item = Cart::Item.new(id: "1", product_id: foreign_product.id, quantity: 1, addon_ids: [])

    result = CalculateOrderTotal.new(@restaurant, [ cart_item ]).call

    assert_empty result.line_items
    assert_equal 0, result.total
  end

  test "ignores an inactive product" do
    @product.update!(active: false)
    cart_item = Cart::Item.new(id: "1", product_id: @product.id, quantity: 1, addon_ids: [])

    result = CalculateOrderTotal.new(@restaurant, [ cart_item ]).call

    assert_empty result.line_items
  end

  test "ignores an addon that does not belong to the product" do
    unrelated_addon = create_addon(@restaurant, price: 99.0)
    cart_item = Cart::Item.new(id: "1", product_id: @product.id, quantity: 1, addon_ids: [ unrelated_addon.id ])

    result = CalculateOrderTotal.new(@restaurant, [ cart_item ]).call

    assert_equal @product.price.to_f, result.total.to_f
  end
end
