module Storefront
  class BaseController < ApplicationController
    layout "storefront"

    before_action :set_restaurant

    helper_method :cart, :show_cart_bar?

    private

    def show_cart_bar?
      true
    end

    # The restaurant is always resolved from the URL slug, never trusted
    # from a client-supplied id/param (see spec regra crítica 2 e 3).
    def set_restaurant
      @restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    end

    def cart
      @cart ||= Cart.new(session)
    end
  end
end
