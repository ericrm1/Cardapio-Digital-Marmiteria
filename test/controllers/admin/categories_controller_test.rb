require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant_a = create_restaurant
    @restaurant_b = create_restaurant
    @user_a = create_admin_user(@restaurant_a)
    @category_a = create_category(@restaurant_a, name: "Categoria de A")
    @category_b = create_category(@restaurant_b, name: "Categoria de B")
  end

  test "redirects to login when not authenticated" do
    get admin_categories_path
    assert_redirected_to new_user_session_path
  end

  test "an admin only sees categories from their own restaurant" do
    sign_in @user_a
    get admin_categories_path

    assert_response :success
    assert_match @category_a.name, response.body
    assert_no_match @category_b.name, response.body
  end

  test "an admin cannot edit a category belonging to another restaurant" do
    sign_in @user_a

    get edit_admin_category_path(@category_b)

    assert_response :not_found
  end

  test "an admin cannot update a category belonging to another restaurant" do
    sign_in @user_a

    patch admin_category_path(@category_b), params: { category: { name: "Hackeado" } }

    assert_response :not_found
    assert_equal "Categoria de B", @category_b.reload.name
  end
end
