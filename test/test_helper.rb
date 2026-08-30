ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def create_restaurant(overrides = {})
      Restaurant.create!({
        name: "Restaurante Teste",
        slug: "restaurante-teste-#{SecureRandom.hex(4)}",
        whatsapp: "5511999999999",
        active: true,
        accepting_orders: true
      }.merge(overrides))
    end

    def open_all_hours_for(restaurant)
      (0..6).each do |day|
        restaurant.business_hours.find_or_create_by!(day_of_week: day) do |h|
          h.active = true
          h.open_time = "00:00"
          h.close_time = "23:59"
        end.update!(active: true, open_time: "00:00", close_time: "23:59")
      end
    end

    def create_category(restaurant, overrides = {})
      restaurant.categories.create!({ name: "Categoria Teste", active: true, position: 0 }.merge(overrides))
    end

    def create_product(restaurant, category, overrides = {})
      restaurant.products.create!({
        category: category,
        name: "Produto Teste",
        price: 10.0,
        active: true,
        position: 0
      }.merge(overrides))
    end

    def create_addon(restaurant, overrides = {})
      restaurant.addons.create!({ name: "Adicional Teste", price: 2.0, active: true }.merge(overrides))
    end

    def create_admin_user(restaurant, overrides = {})
      User.create!({
        name: "Admin Teste",
        email: "admin-#{SecureRandom.hex(4)}@example.com",
        password: "password123",
        restaurant: restaurant
      }.merge(overrides))
    end
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
