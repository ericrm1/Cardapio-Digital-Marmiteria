module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: [ :edit, :update, :destroy ]

    def index
      @categories = @restaurant.categories.ordered
    end

    def new
      @category = @restaurant.categories.new
    end

    def create
      @category = @restaurant.categories.new(category_params)

      if @category.save
        redirect_to admin_categories_path, notice: "Categoria criada com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Categoria atualizada com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path, notice: "Categoria removida com sucesso."
      else
        redirect_to admin_categories_path, alert: "Não é possível remover uma categoria que possui produtos."
      end
    end

    private

    def set_category
      @category = @restaurant.categories.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :position, :active)
    end
  end
end
