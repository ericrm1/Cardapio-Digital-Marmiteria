class Restaurant < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :addons, dependent: :destroy
  has_many :business_hours, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_one_attached :logo

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
                    format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "só pode conter letras minúsculas, números e hífens" }
  validates :whatsapp, presence: true

  before_validation :normalize_whatsapp

  def whatsapp_link_number
    whatsapp
  end

  def open_now?
    hours = business_hours.find_by(day_of_week: Time.zone.now.wday, active: true)
    return false unless hours&.open_time && hours.close_time

    now = Time.zone.now.strftime("%H:%M:%S")
    now.between?(hours.open_time.strftime("%H:%M:%S"), hours.close_time.strftime("%H:%M:%S"))
  end

  private

  def normalize_whatsapp
    self.whatsapp = whatsapp.gsub(/\D/, "") if whatsapp.present?
  end
end
