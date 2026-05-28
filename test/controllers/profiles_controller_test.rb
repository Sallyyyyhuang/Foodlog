require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  VALID_PARAMS = {
    profile: {
      gender:         "female",
      age:            30,
      weight_kg:      65.0,
      height_cm:      168.0,
      activity_level: "moderate"
    }
  }.freeze

  setup do
    Profile.delete_all
  end

  # --- show ---

  test "show redirects to edit when no profile exists" do
    get profile_url
    assert_redirected_to edit_profile_url
  end

  test "show renders profile when profile exists" do
    Profile.create!(VALID_PARAMS[:profile])
    get profile_url
    assert_response :success
  end

  # --- edit ---

  test "edit renders form" do
    get edit_profile_url
    assert_response :success
  end

  # --- update (first-time save) ---

  test "update creates profile when none exists" do
    assert_difference "Profile.count", 1 do
      patch profile_url, params: VALID_PARAMS
    end
    assert_redirected_to profile_url
    assert_equal "female", Profile.first.gender
  end

  test "update saves correct field values" do
    patch profile_url, params: VALID_PARAMS
    p = Profile.first
    assert_equal "female",   p.gender
    assert_equal 30,         p.age
    assert_in_delta 65.0,    p.weight_kg, 0.01
    assert_in_delta 168.0,   p.height_cm, 0.01
    assert_equal "moderate", p.activity_level
  end

  test "update does not create a second profile on subsequent saves" do
    patch profile_url, params: VALID_PARAMS
    assert_no_difference "Profile.count" do
      patch profile_url, params: { profile: VALID_PARAMS[:profile].merge(age: 31) }
    end
    assert_equal 31, Profile.first.age
  end

  test "update with missing fields re-renders edit" do
    patch profile_url, params: { profile: { gender: "", age: "", weight_kg: "", height_cm: "", activity_level: "" } }
    assert_response :unprocessable_entity
    assert Profile.count.zero?
  end

  # --- calorie goal calculation ---

  test "daily_calorie_goal returns a positive integer for female moderate profile" do
    patch profile_url, params: VALID_PARAMS
    goal = Profile.first.daily_calorie_goal
    # Female 30yo 65kg 168cm moderate: BMR = 1389, TDEE = 1389 * 1.55 ≈ 2153
    assert goal > 0
    assert_in_delta 2153, goal, 5
  end

  test "daily_calorie_goal is higher for male than female with same stats" do
    patch profile_url, params: VALID_PARAMS
    female_goal = Profile.first.daily_calorie_goal

    patch profile_url, params: { profile: VALID_PARAMS[:profile].merge(gender: "male") }
    male_goal = Profile.first.daily_calorie_goal

    assert male_goal > female_goal
  end
end
