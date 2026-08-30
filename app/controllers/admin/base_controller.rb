module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :set_restaurant

    private

    # Every admin query must go through current_restaurant so an admin can
    # never read or write another restaurant's data (see spec regra 44/55).
    def set_restaurant
      @restaurant = current_user.restaurant
    end

    attr_reader :restaurant
  end
end
