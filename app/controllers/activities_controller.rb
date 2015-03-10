class ActivitiesController < ApplicationController
  before_action :set_type

  def index
    @activities = type_class.paginate(page: params[:page])
    @mileage = type_class.group_mileage_by_month
    @activities_in_last_year = type_class.activities_in_last_year
    @distance_in_last_year = @activities_in_last_year.sum_distance
    @time_in_last_year = @activities_in_last_year.sum_time
    @elevation_gain_in_last_year = @activities_in_last_year.sum_elevation_gain
  end

  def show
    @activity = Activity.find(params[:id])
    @polyline = @activity.get_geo_points_lat_lng.to_json
    @heart_rate = @activity.get_geo_points_heart_rate
    @elevation = @activity.get_geo_points_elevation
    @pace = @activity.get_geo_points_pace
  end

  def new
    @activity = Activity.new
    @types = Activity.types
  end

  def create
    @activity = Activity.new(activity_params)
    @types = Activity.types
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
      params.require(type.underscore.to_sym).permit(:type, :geo_route)
    end

    def set_type
      @type = type
    end

    def type
      Activity.types.include?(params[:type]) ? params[:type] : 'Activity'
    end

    def type_class
      type.constantize
    end
end
