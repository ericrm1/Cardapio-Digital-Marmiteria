module Admin
  class DashboardController < BaseController
    def show
      @products_count = @restaurant.products.count
      @categories_count = @restaurant.categories.count
      @orders_today_count = @restaurant.orders.where(created_at: Time.zone.now.all_day).count
    end
  end
end
