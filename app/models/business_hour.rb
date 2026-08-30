class BusinessHour < ApplicationRecord
  DAYS = %w[domingo segunda terca quarta quinta sexta sabado].freeze

  belongs_to :restaurant

  validates :day_of_week, presence: true, inclusion: { in: 0..6 }, uniqueness: { scope: :restaurant_id }
  validates :open_time, :close_time, presence: true, if: :active?
  validate :close_after_open

  def day_name
    DAYS[day_of_week]
  end

  private

  def close_after_open
    return if open_time.blank? || close_time.blank?

    errors.add(:close_time, "deve ser depois do horário de abertura") if close_time <= open_time
  end
end
