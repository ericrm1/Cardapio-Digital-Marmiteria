class Order < ApplicationRecord
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy

  enum :status, { pending: 0, sent_to_whatsapp: 1, cancelled: 2 }

  validates :customer_name, presence: true
  validates :customer_phone, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_at_least_one_item

  before_validation :normalize_customer_phone

  private

  def normalize_customer_phone
    self.customer_phone = customer_phone.gsub(/\D/, "") if customer_phone.present?
  end

  def must_have_at_least_one_item
    errors.add(:order_items, "deve ter pelo menos um item") if order_items.reject(&:marked_for_destruction?).empty?
  end
end
