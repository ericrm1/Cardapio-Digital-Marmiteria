require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  test "requires name, slug and whatsapp" do
    restaurant = Restaurant.new
    assert_not restaurant.valid?
    assert_includes restaurant.errors.attribute_names, :name
    assert_includes restaurant.errors.attribute_names, :slug
    assert_includes restaurant.errors.attribute_names, :whatsapp
  end

  test "slug must be unique" do
    create_restaurant(slug: "duplicado")
    other = Restaurant.new(name: "Outro", slug: "duplicado", whatsapp: "5511988887777")
    assert_not other.valid?
    assert_includes other.errors[:slug], "já está em uso"
  end

  test "normalizes whatsapp to digits only" do
    restaurant = create_restaurant(whatsapp: "(61) 99999-9999")
    assert_equal "61999999999", restaurant.whatsapp
  end

  test "open_now? is false without matching business hours" do
    restaurant = create_restaurant
    assert_not restaurant.open_now?
  end

  test "open_now? is true when today's business hours cover the current time" do
    restaurant = create_restaurant
    open_all_hours_for(restaurant)
    assert restaurant.open_now?
  end
end
