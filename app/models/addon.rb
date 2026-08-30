class Addon < ApplicationRecord
  belongs_to :restaurant
  has_many :product_addons, dependent: :destroy
  has_many :products, through: :product_addons

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
end
