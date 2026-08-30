require "test_helper"

class CreateOrderTest < ActiveSupport::TestCase
  setup do
    @restaurant = create_restaurant
    open_all_hours_for(@restaurant)
    @category = create_category(@restaurant)
    @product = create_product(@restaurant, @category, price: 25.0)
    @addon = create_addon(@restaurant, price: 3.0)
    ProductAddon.create!(product: @product, addon: @addon)
  end

  def cart_items
    [ Cart::Item.new(id: "1", product_id: @product.id, quantity: 2, observation: "Sem cebola", addon_ids: [ @addon.id ]) ]
  end

  test "creates the order, items and addon snapshots inside a transaction" do
    result = CreateOrder.new(
      restaurant: @restaurant,
      cart_items: cart_items,
      customer_name: "Joao Silva",
      customer_phone: "(61) 98888-7777"
    ).call

    assert result.success?
    order = result.order
    assert order.persisted?
    assert order.sent_to_whatsapp?
    assert_equal "61988887777", order.customer_phone
    assert_equal 56.0, order.total.to_f

    item = order.order_items.sole
    assert_equal @product.name, item.product_name
    assert_equal "Sem cebola", item.observation

    addon_line = item.order_item_addons.sole
    assert_equal @addon.name, addon_line.addon_name
    assert_equal 3.0, addon_line.price.to_f
  end

  test "does not create an order when the restaurant is not accepting orders" do
    @restaurant.update!(accepting_orders: false)

    result = CreateOrder.new(
      restaurant: @restaurant,
      cart_items: cart_items,
      customer_name: "Joao Silva",
      customer_phone: "61988887777"
    ).call

    assert_not result.success?
    assert_equal 0, Order.count
  end

  test "does not create an order for an empty cart" do
    result = CreateOrder.new(
      restaurant: @restaurant,
      cart_items: [],
      customer_name: "Joao Silva",
      customer_phone: "61988887777"
    ).call

    assert_not result.success?
    assert_equal 0, Order.count
  end

  test "does not persist anything when order validation fails" do
    result = CreateOrder.new(
      restaurant: @restaurant,
      cart_items: cart_items,
      customer_name: "",
      customer_phone: ""
    ).call

    assert_not result.success?
    assert_equal 0, Order.count
    assert_equal 0, OrderItem.count
  end
end
