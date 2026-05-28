class Activity < ApplicationRecord
  validates :activity_type, :logged_at, presence: true

  before_save :calculate_calories

  scope :today, -> { where("logged_at >= ?", Date.today) }

  ACTIVITY_TYPES = %w[weight_training bouldering running walking].freeze

  private

  def calculate_calories
    profile = Profile.first
    weight_kg = profile&.weight_kg || 70

    duration = if activity_type == "walking" && steps.present?
      steps.to_f / 100.0  # 100 steps/minute → minutes
    else
      duration_minutes.to_f
    end

    self.calories_burned = CalorieCalculator.activity_calories(
      activity_type:    activity_type,
      weight_kg:        weight_kg,
      duration_minutes: duration
    ).round
  end
end
