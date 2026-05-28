class CalorieCalculator
  ACTIVITY_MULTIPLIERS = {
    "sedentary"   => 1.2,
    "light"       => 1.375,
    "moderate"    => 1.55,
    "active"      => 1.725,
    "very_active" => 1.9
  }.freeze

  ACTIVITY_METS = {
    "weight_training" => 4.0,
    "bouldering"      => 5.5,
    "running"         => 9.8,
    "walking"         => 3.5
  }.freeze

  def self.bmr(gender:, weight_kg:, height_cm:, age:)
    base = 10 * weight_kg.to_f + 6.25 * height_cm.to_f - 5 * age.to_i
    gender.to_s.downcase == "male" ? base + 5 : base - 161
  end

  def self.tdee(gender:, weight_kg:, height_cm:, age:, activity_level:)
    multiplier = ACTIVITY_MULTIPLIERS[activity_level.to_s] || 1.2
    bmr(gender: gender, weight_kg: weight_kg, height_cm: height_cm, age: age) * multiplier
  end

  def self.activity_calories(activity_type:, weight_kg:, duration_minutes:)
    met = ACTIVITY_METS[activity_type.to_s] || 3.5
    met * weight_kg.to_f * (duration_minutes.to_f / 60)
  end
end
