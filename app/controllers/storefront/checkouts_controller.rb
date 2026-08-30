module Storefront
  class CheckoutsController < BaseController
    def show
      @calculation = CalculateOrderTotal.new(@restaurant, cart.items).call
      @availability = CheckRestaurantAvailability.new(@restaurant).call

      redirect_to storefront_cart_path(@restaurant.slug), alert: "Seu carrinho está vazio." if @calculation.line_items.empty?
    end

    private

    def show_cart_bar?
      false
    end
  end
end
