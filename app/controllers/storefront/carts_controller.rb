module Storefront
  class CartsController < BaseController
    def show
      @calculation = CalculateOrderTotal.new(@restaurant, cart.items).call
    end

    private

    def show_cart_bar?
      false
    end
  end
end
