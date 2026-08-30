class GenerateWhatsappUrl
  def initialize(order)
    @order = order
  end

  def call
    message = GenerateWhatsappMessage.new(@order).call
    "https://wa.me/#{@order.restaurant.whatsapp}?text=#{ERB::Util.url_encode(message)}"
  end
end
