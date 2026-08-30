require "test_helper"

class GenerateWhatsappMessageTest < ActiveSupport::TestCase
  test "renders customer, items, addons, observation and total" do
    restaurant = create_restaurant(name: "Marmitaria Sabor da Casa")
    category = create_category(restaurant)
    product = create_product(restaurant, category, name: "Parmegiana de Frango", price: 25.0)
    addon = create_addon(restaurant, name: "Queijo extra", price: 3.0)
    ProductAddon.create!(product: product, addon: addon)

    order = Order.new(restaurant: restaurant, customer_name: "Joao Silva", customer_phone: "61988887777", total: 28.0, status: :sent_to_whatsapp)
    item = order.order_items.build(product: product, product_name: product.name, unit_price: product.price, quantity: 1, observation: "Sem cebola", subtotal: 28.0)
    item.order_item_addons.build(addon: addon, addon_name: addon.name, price: addon.price, quantity: 1, subtotal: addon.price)
    order.save!

    message = GenerateWhatsappMessage.new(order).call

    assert_includes message, "Pedido - Marmitaria Sabor da Casa"
    assert_includes message, "Cliente: Joao Silva"
    assert_includes message, "WhatsApp: 61988887777"
    assert_includes message, "1x Parmegiana de Frango"
    assert_includes message, "Queijo extra"
    assert_includes message, "Sem cebola"
    assert_includes message, "Total: R$ 28,00"
  end
end
