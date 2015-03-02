class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    @activity = Activity.new
    @types = Activity.types
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to activities_url
    else
      render 'new'
    end
  end

  def edit
    @activity = Activity.find(params[:id])
    @types = Activity.types
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(activity_params)
      flash.now[:success] = "Changes saved"
      redirect_to @activity
    else
      render 'edit'
    end
  end

  def destroy
    activity = Activity.find(params[:id])
    if activity.destroy
      flash.now[:success] = "Activity successfully deleted"
      redirect_to activities_url
    else
      render 'edit'
    end
  end

  private

    def activity_params
      params.require(:activity).permit(
        :type, :logged_date, :start_time,
        :end_time, :total_elevation_gain, :total_elevation_loss,
        :total_time, :total_distance, :average_speed,
        :average_pace, :max_elevation, :min_elevation,
        :max_heart_rate, :min_heart_rate, :total_calories,
        :quality, :geo_route_file)
    end
end
