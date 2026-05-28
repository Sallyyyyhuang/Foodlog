class ProfilesController < ApplicationController
  def show
    @profile = Profile.first
    redirect_to edit_profile_path if @profile.nil?
  end

  def edit
    @profile = Profile.first || Profile.new
  end

  def update
    @profile = Profile.first || Profile.new

    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Profile saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.expect(profile: [ :gender, :age, :weight_kg, :height_cm, :activity_level ])
  end
end
