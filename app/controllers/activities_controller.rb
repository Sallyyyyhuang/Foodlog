class ActivitiesController < ApplicationController
  def index
    @activities = Activity.today.order(logged_at: :desc)
    @total_burned = @activities.sum(:calories_burned)
  end

  def new
    @activity = Activity.new(logged_at: Time.current)
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to activities_path, notice: "Activity logged."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    Activity.find(params[:id]).destroy
    redirect_to activities_path, status: :see_other, notice: "Activity deleted."
  end

  private

  def activity_params
    params.expect(activity: [ :activity_type, :duration_minutes, :steps, :logged_at ])
  end
end
