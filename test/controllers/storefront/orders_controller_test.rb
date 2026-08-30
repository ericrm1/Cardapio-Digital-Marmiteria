require "test_helper"

class Storefront::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = create_restaurant
    open_all_hours_for(@restaurant)
    @category = create_category(@restaurant)
    @product = create_product(@restaurant, @category, price: 25.0)
  end

  def add_product_to_cart(product_id: @product.id, quantity: 2)
    post storefront_cart_items_path(@restaurant.slug), params: { product_id: product_id, quantity: quantity }
  end

  test "creates the order and redirects to the confirmation page" do
    add_product_to_cart

    assert_difference "Order.count", 1 do
      post storefront_orders_path(@restaurant.slug), params: { customer_name: "Joao Silva", customer_phone: "61988887777" }
    end

    order = Order.last
    assert_redirected_to storefront_order_path(@restaurant.slug, order)
    assert_equal 50.0, order.total.to_f
  end

  test "recalculates the total from the database even if the client tampers with the price" do
    post storefront_cart_items_path(@restaurant.slug), params: { product_id: @product.id, quantity: 1, price: "0.01" }

    post storefront_orders_path(@restaurant.slug), params: { customer_name: "Joao Silva", customer_phone: "61988887777" }

    order = Order.last
    assert_equal @product.price.to_f, order.total.to_f
  end

  test "does not create an order when the restaurant is closed" do
    @restaurant.business_hours.update_all(active: false)
    add_product_to_cart

    assert_no_difference "Order.count" do
      post storefront_orders_path(@restaurant.slug), params: { customer_name: "Joao Silva", customer_phone: "61988887777" }
    end

    assert_redirected_to storefront_checkout_path(@restaurant.slug)
  end

  test "a product from another restaurant cannot be added to this restaurant's order" do
    other_restaurant = create_restaurant
    other_category = create_category(other_restaurant)
    foreign_product = create_product(other_restaurant, other_category, price: 999.0)

    add_product_to_cart(product_id: foreign_product.id, quantity: 1)

    assert_no_difference "Order.count" do
      post storefront_orders_path(@restaurant.slug), params: { customer_name: "Joao Silva", customer_phone: "61988887777" }
    end
  end
end
