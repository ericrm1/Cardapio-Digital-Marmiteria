module Storefront
  class ProductsController < BaseController
    def show
      @product = @restaurant.products.active.find(params[:id])
      @addons = @product.addons.active.order(:name)
    end
  end
end
