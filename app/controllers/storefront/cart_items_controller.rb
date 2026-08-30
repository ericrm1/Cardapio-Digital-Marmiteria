module Storefront
  class CartItemsController < BaseController
    def create
      product = @restaurant.products.active.find_by(id: params[:product_id])

      unless product
        return redirect_to storefront_menu_path(@restaurant.slug), alert: "Produto não encontrado."
      end

      cart.add(
        product_id: product.id,
        quantity: params[:quantity].presence || 1,
        observation: params[:observation],
        addon_ids: Array(params[:addon_ids]).reject(&:blank?)
      )

      redirect_to storefront_menu_path(@restaurant.slug), notice: "Produto adicionado ao carrinho."
    end

    def update
      cart.update(
        params[:id],
        quantity: params[:quantity],
        observation: params[:observation],
        addon_ids: params[:addon_ids] && Array(params[:addon_ids]).reject(&:blank?)
      )

      redirect_to storefront_cart_path(@restaurant.slug)
    end

    def destroy
      cart.remove(params[:id])
      redirect_to storefront_cart_path(@restaurant.slug)
    end
  end
end
