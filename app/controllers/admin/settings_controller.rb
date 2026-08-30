module Admin
  class SettingsController < BaseController
    def show
    end

    def update
      if @restaurant.update(settings_params)
        redirect_to admin_settings_path, notice: "Configurações atualizadas com sucesso."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def settings_params
      params.require(:restaurant).permit(:name, :whatsapp, :slug, :logo, :active, :accepting_orders)
    end
  end
end
