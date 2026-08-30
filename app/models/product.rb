class Product < ApplicationRecord
  belongs_to :restaurant
  belongs_to :category
  has_many :product_addons, dependent: :destroy
  has_many :addons, through: :product_addons
  has_many :order_items, dependent: :restrict_with_error

  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :category_belongs_to_same_restaurant

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  private

  def category_belongs_to_same_restaurant
    return if category.nil? || restaurant_id.nil?

    errors.add(:category, "deve pertencer ao mesmo restaurante do produto") if category.restaurant_id != restaurant_id
  end
end
