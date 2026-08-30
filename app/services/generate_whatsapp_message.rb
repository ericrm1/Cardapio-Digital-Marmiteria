class GenerateWhatsappMessage
  include ActionView::Helpers::NumberHelper

  def initialize(order)
    @order = order
  end

  def call
    lines = [
      "Olá! Gostaria de fazer um pedido.",
      "",
      "*Pedido - #{@order.restaurant.name}*",
      "",
      "Cliente: #{@order.customer_name}",
      "WhatsApp: #{@order.customer_phone}",
      "",
      "*Itens:*",
      ""
    ]

    @order.order_items.each do |item|
      lines << "#{item.quantity}x #{item.product_name} — #{money(item.unit_price)}"

      if item.order_item_addons.any?
        lines << "Adicionais:"
        item.order_item_addons.each do |addon|
          lines << "- #{addon.addon_name} — #{money(addon.price)}"
        end
      end

      lines << "Observação: #{item.observation}" if item.observation.present?
      lines << ""
    end

    lines << "*Total: #{money(@order.total)}*"
    lines.join("\n")
  end

  private

  def money(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".", format: "%u%n")
  end
end
