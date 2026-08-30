module Storefront
  class OrdersController < BaseController
    def create
      result = CreateOrder.new(
        restaurant: @restaurant,
        cart_items: cart.items,
        customer_name: params[:customer_name],
        customer_phone: params[:customer_phone]
      ).call

      if result.success?
        cart.clear
        redirect_to storefront_order_path(@restaurant.slug, result.order)
      else
        redirect_to storefront_checkout_path(@restaurant.slug), alert: result.errors.to_sentence
      end
    end

    def show
      @order = @restaurant.orders.find(params[:id])
      @whatsapp_url = GenerateWhatsappUrl.new(@order).call
    end

    private

    def show_cart_bar?
      false
    end
  end
end
