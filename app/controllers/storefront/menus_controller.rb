module Storefront
  class MenusController < BaseController
    def show
      @categories = @restaurant.categories.active.ordered.includes(products: { image_attachment: :blob })
      @availability = CheckRestaurantAvailability.new(@restaurant).call
      @cart_items_count = cart.items.sum(&:quantity)
    end
  end
end
