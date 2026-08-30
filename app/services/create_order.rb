class CreateOrder
  Result = Struct.new(:success, :order, :errors, keyword_init: true) do
    def success?
      success
    end
  end

  def initialize(restaurant:, cart_items:, customer_name:, customer_phone:)
    @restaurant = restaurant
    @cart_items = cart_items
    @customer_name = customer_name
    @customer_phone = customer_phone
  end

  def call
    availability = CheckRestaurantAvailability.new(@restaurant).call
    return Result.new(success: false, errors: [ unavailable_message(availability.reason) ]) unless availability.available?

    calculation = CalculateOrderTotal.new(@restaurant, @cart_items).call
    return Result.new(success: false, errors: [ "Carrinho vazio ou produtos indisponíveis." ]) if calculation.line_items.empty?

    order = build_order(calculation)
    Result.new(success: true, order: order, errors: [])
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success: false, order: nil, errors: [ e.message ])
  end

  private

  # Order#must_have_at_least_one_item requires the items to already be present
  # when the order itself is validated, so everything is built in memory and
  # saved once via autosave rather than creating the order row first.
  def build_order(calculation)
    order = nil

    ActiveRecord::Base.transaction do
      order = @restaurant.orders.new(
        customer_name: @customer_name,
        customer_phone: @customer_phone,
        total: calculation.total,
        status: :sent_to_whatsapp
      )

      calculation.line_items.each do |line|
        order_item = order.order_items.build(
          product: line.product,
          product_name: line.product.name,
          unit_price: line.unit_price,
          quantity: line.quantity,
          observation: line.observation,
          subtotal: line.item_subtotal
        )

        line.addons.each do |addon_line|
          order_item.order_item_addons.build(
            addon: addon_line.addon,
            addon_name: addon_line.addon.name,
            price: addon_line.unit_price,
            quantity: addon_line.quantity,
            subtotal: addon_line.subtotal
          )
        end
      end

      order.save!
    end

    order
  end

  def unavailable_message(reason)
    case reason
    when :not_accepting_orders then "Pedidos encerrados no momento."
    when :closed then "Estamos fechados no momento."
    else "Restaurante indisponível no momento."
    end
  end
end
