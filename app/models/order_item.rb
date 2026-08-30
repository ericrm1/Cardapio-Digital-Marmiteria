class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_many :order_item_addons, dependent: :destroy

  validates :product_name, presence: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :subtotal, numericality: { greater_than_or_equal_to: 0 }
end
