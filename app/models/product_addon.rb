class ProductAddon < ApplicationRecord
  belongs_to :product
  belongs_to :addon

  validates :addon_id, uniqueness: { scope: :product_id }
  validate :addon_belongs_to_same_restaurant

  private

  def addon_belongs_to_same_restaurant
    return if product.nil? || addon.nil?

    errors.add(:addon, "deve pertencer ao mesmo restaurante do produto") if addon.restaurant_id != product.restaurant_id
  end
end
