require "test_helper"

class ProductAddonTest < ActiveSupport::TestCase
  setup do
    @restaurant = create_restaurant
    @category = create_category(@restaurant)
    @product = create_product(@restaurant, @category)
    @addon = create_addon(@restaurant)
  end

  test "does not allow the same addon twice on a product" do
    ProductAddon.create!(product: @product, addon: @addon)
    duplicate = ProductAddon.new(product: @product, addon: @addon)

    assert_not duplicate.valid?
    assert_includes duplicate.errors.attribute_names, :addon_id
  end

  test "rejects an addon belonging to another restaurant" do
    other_restaurant = create_restaurant
    foreign_addon = create_addon(other_restaurant)

    product_addon = ProductAddon.new(product: @product, addon: foreign_addon)

    assert_not product_addon.valid?
    assert_includes product_addon.errors.attribute_names, :addon
  end
end
