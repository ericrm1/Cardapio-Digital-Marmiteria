class OrderItemAddon < ApplicationRecord
  belongs_to :order_item
  belongs_to :addon

  validates :addon_name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }
end
