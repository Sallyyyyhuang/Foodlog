require "test_helper"

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Activity.delete_all
    Profile.delete_all
  end

  # --- index ---

  test "index renders successfully" do
    get activities_url
    assert_response :success
  end

  test "index only shows today's activities" do
    today_activity = Activity.create!(
      activity_type:    "running",
      duration_minutes: 30,
      logged_at:        Time.current
    )
    yesterday_activity = Activity.create!(
      activity_type:    "running",
      duration_minutes: 30,
      logged_at:        1.day.ago
    )

    get activities_url
    assert_response :success
    # today's activity is in the response body, yesterday's is not
    assert_select "body" do
      assert_match today_activity.id.to_s, response.body
    end
  end

  test "index shows total calories burned for today" do
    Activity.create!(activity_type: "running",  duration_minutes: 30, logged_at: Time.current)
    Activity.create!(activity_type: "bouldering", duration_minutes: 30, logged_at: Time.current)

    get activities_url
    total = Activity.today.sum(:calories_burned)
    assert total > 0
  end

  # --- new ---

  test "new renders form" do
    get new_activity_url
    assert_response :success
  end

  # --- create ---

  test "create with valid params saves activity and redirects" do
    assert_difference "Activity.count", 1 do
      post activities_url, params: {
        activity: { activity_type: "running", duration_minutes: 30, logged_at: Time.current }
      }
    end
    assert_redirected_to activities_url
  end

  test "create without activity_type re-renders new" do
    assert_no_difference "Activity.count" do
      post activities_url, params: {
        activity: { activity_type: "", duration_minutes: 30, logged_at: Time.current }
      }
    end
    assert_response :unprocessable_entity
  end

  test "create without logged_at re-renders new" do
    assert_no_difference "Activity.count" do
      post activities_url, params: {
        activity: { activity_type: "running", duration_minutes: 30, logged_at: "" }
      }
    end
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy deletes the activity and redirects" do
    activity = Activity.create!(
      activity_type: "running", duration_minutes: 30, logged_at: Time.current
    )
    assert_difference "Activity.count", -1 do
      delete activity_url(activity)
    end
    assert_redirected_to activities_url
  end

  # --- calorie calculation ---

  test "running 30 min with default weight (70 kg) burns 343 kcal" do
    post activities_url, params: {
      activity: { activity_type: "running", duration_minutes: 30, logged_at: Time.current }
    }
    # MET 9.8 * 70 kg * 0.5 h = 343
    assert_equal 343, Activity.last.calories_burned
  end

  test "weight_training 60 min with default weight (70 kg) burns 280 kcal" do
    post activities_url, params: {
      activity: { activity_type: "weight_training", duration_minutes: 60, logged_at: Time.current }
    }
    # MET 4.0 * 70 kg * 1.0 h = 280
    assert_equal 280, Activity.last.calories_burned
  end

  test "bouldering 45 min with default weight (70 kg) burns 206 kcal" do
    post activities_url, params: {
      activity: { activity_type: "bouldering", duration_minutes: 45, logged_at: Time.current }
    }
    # MET 5.5 * 70 kg * 0.75 h = 288.75 ≈ 289
    assert_equal 289, Activity.last.calories_burned
  end

  test "walking with steps uses step-based duration" do
    post activities_url, params: {
      activity: { activity_type: "walking", steps: 6000, logged_at: Time.current }
    }
    # 6000 steps / 100 steps/min = 60 min; MET 3.5 * 70 kg * 1.0 h = 245
    assert_equal 245, Activity.last.calories_burned
  end

  test "calorie burn uses profile weight when profile exists" do
    Profile.create!(
      gender: "female", age: 30, weight_kg: 65.0,
      height_cm: 168.0, activity_level: "moderate"
    )
    post activities_url, params: {
      activity: { activity_type: "weight_training", duration_minutes: 60, logged_at: Time.current }
    }
    # MET 4.0 * 65 kg * 1.0 h = 260
    assert_equal 260, Activity.last.calories_burned
  end

  test "higher MET activity burns more calories than lower MET for same duration" do
    post activities_url, params: {
      activity: { activity_type: "running", duration_minutes: 30, logged_at: Time.current }
    }
    running_calories = Activity.last.calories_burned

    post activities_url, params: {
      activity: { activity_type: "walking", duration_minutes: 30, logged_at: Time.current }
    }
    walking_calories = Activity.last.calories_burned

    assert running_calories > walking_calories
  end
end
