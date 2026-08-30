class CalculateOrderTotal
  Result = Struct.new(:line_items, :total, keyword_init: true)
  LineItem = Struct.new(:cart_item_id, :product, :quantity, :observation, :unit_price, :addons, :item_subtotal, keyword_init: true)
  AddonLine = Struct.new(:addon, :quantity, :unit_price, :subtotal, keyword_init: true)

  # cart_items: enumerable of objects responding to product_id, quantity, observation, addon_ids
  def initialize(restaurant, cart_items)
    @restaurant = restaurant
    @cart_items = cart_items
  end

  def call
    line_items = @cart_items.filter_map { |cart_item| build_line_item(cart_item) }
    total = line_items.sum(&:item_subtotal)
    Result.new(line_items: line_items, total: total)
  end

  private

  def build_line_item(cart_item)
    product = @restaurant.products.active.find_by(id: cart_item.product_id)
    return nil unless product

    quantity = cart_item.quantity.to_i.clamp(1, 99)

    addon_lines = Array(cart_item.addon_ids).filter_map do |addon_id|
      addon = product.addons.active.find_by(id: addon_id)
      next nil unless addon

      AddonLine.new(addon: addon, quantity: quantity, unit_price: addon.price, subtotal: addon.price * quantity)
    end

    addons_total = addon_lines.sum(&:subtotal)
    item_subtotal = (product.price * quantity) + addons_total

    LineItem.new(
      cart_item_id: cart_item.respond_to?(:id) ? cart_item.id : nil,
      product: product,
      quantity: quantity,
      observation: cart_item.observation,
      unit_price: product.price,
      addons: addon_lines,
      item_subtotal: item_subtotal
    )
  end
end
