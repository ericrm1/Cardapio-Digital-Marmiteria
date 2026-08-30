class Category < ApplicationRecord
  belongs_to :restaurant
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  def active_products
    products.active.ordered
  end
end
