require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @restaurant = create_restaurant
    @category = create_category(@restaurant)
    @product = create_product(@restaurant, @category)
  end

  test "requires customer_name and customer_phone" do
    order = Order.new(restaurant: @restaurant, total: 0)
    order.order_items.build(product: @product, product_name: @product.name, unit_price: @product.price, quantity: 1, subtotal: @product.price)

    assert_not order.valid?
    assert_includes order.errors.attribute_names, :customer_name
    assert_includes order.errors.attribute_names, :customer_phone
  end

  test "requires at least one order item" do
    order = Order.new(restaurant: @restaurant, customer_name: "Joao", customer_phone: "5511999999999", total: 0)

    assert_not order.valid?
    assert_includes order.errors.attribute_names, :order_items
  end

  test "is valid with customer data and at least one item" do
    order = Order.new(restaurant: @restaurant, customer_name: "Joao", customer_phone: "5511999999999", total: @product.price)
    order.order_items.build(product: @product, product_name: @product.name, unit_price: @product.price, quantity: 1, subtotal: @product.price)

    assert order.valid?
  end
end
