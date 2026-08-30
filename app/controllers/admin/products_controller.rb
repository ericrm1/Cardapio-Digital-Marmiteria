module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [ :edit, :update, :destroy ]
    before_action :set_categories_and_addons, only: [ :new, :create, :edit, :update ]

    def index
      @products = @restaurant.products.includes(:category).ordered
    end

    def new
      @product = @restaurant.products.new
    end

    def create
      @product = @restaurant.products.new(product_params)

      if @product.save
        redirect_to admin_products_path, notice: "Produto criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Produto atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Produto removido com sucesso."
    end

    private

    def set_product
      @product = @restaurant.products.find(params[:id])
    end

    def set_categories_and_addons
      @categories = @restaurant.categories.ordered
      @addons = @restaurant.addons.order(:name)
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :category_id, :active, :position, :image, addon_ids: [])
    end
  end
end
