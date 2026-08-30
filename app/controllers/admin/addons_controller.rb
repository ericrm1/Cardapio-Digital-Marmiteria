module Admin
  class AddonsController < BaseController
    before_action :set_addon, only: [ :edit, :update, :destroy ]

    def index
      @addons = @restaurant.addons.order(:name)
    end

    def new
      @addon = @restaurant.addons.new
    end

    def create
      @addon = @restaurant.addons.new(addon_params)

      if @addon.save
        redirect_to admin_addons_path, notice: "Adicional criado com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @addon.update(addon_params)
        redirect_to admin_addons_path, notice: "Adicional atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @addon.destroy
      redirect_to admin_addons_path, notice: "Adicional removido com sucesso."
    end

    private

    def set_addon
      @addon = @restaurant.addons.find(params[:id])
    end

    def addon_params
      params.require(:addon).permit(:name, :price, :active)
    end
  end
end
