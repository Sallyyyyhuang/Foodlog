class Profile < ApplicationRecord
  validates :gender, :age, :weight_kg, :height_cm, :activity_level, presence: true

  ACTIVITY_LEVELS = %w[sedentary light moderate active very_active].freeze
  GENDERS = %w[male female].freeze

  def daily_calorie_goal
    CalorieCalculator.tdee(
      gender:         gender,
      weight_kg:      weight_kg,
      height_cm:      height_cm,
      age:            age,
      activity_level: activity_level
    ).round
  end
end
