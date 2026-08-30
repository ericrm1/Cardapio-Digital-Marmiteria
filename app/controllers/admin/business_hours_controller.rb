module Admin
  class BusinessHoursController < BaseController
    def index
      @business_hours = @restaurant.business_hours.order(:day_of_week)
    end

    def update
      business_hour = @restaurant.business_hours.find(params[:id])

      if business_hour.update(business_hour_params)
        redirect_to admin_business_hours_path, notice: "Horário atualizado com sucesso."
      else
        redirect_to admin_business_hours_path, alert: business_hour.errors.full_messages.to_sentence
      end
    end

    private

    def business_hour_params
      params.require(:business_hour).permit(:open_time, :close_time, :active)
    end
  end
end
