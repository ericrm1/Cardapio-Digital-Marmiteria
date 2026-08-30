module Admin
  class StoreController < BaseController
    def toggle
      @restaurant.update!(accepting_orders: !@restaurant.accepting_orders?)
      redirect_to admin_root_path
    end
  end
end
