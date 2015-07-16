class ActivitiesController < ApplicationController
  def index
    @activities = Activity.page(params[:page])
    @lifetime = Activity.all
    @last_year = Activity.find_by_period(1.year)
    @last_month = Activity.find_by_period(1.month)
    @last_week = Activity.find_by_period(1.week)
  end

  def show
    @activity = Activity.find(params[:id])
    @laps = Lap.where(activity: @activity)
    @activity_presenter = ActivityPresenter.new(@activity)
    @polyline = @activity.geo_points_lat_lng.to_json
  end

  def destroy
    @activity = Activity.find(params[:id])
    flash.now[:success] = 'Activity successfully deleted' if @activity.destroy
    redirect_to activities_url
  end

  def analytics
    @by_day_of_week = Activity.analytics_by_day_of_week
    @by_month = Activity.analytics_by_month_of_year
  end

  def mileage
    render json: Activity.group_mileage_by_month
  end

  def heart_rate
    render json: Activity.find(params[:id]).geo_route_heart_rate
  end

  def elevation
    render json: Activity.find(params[:id]).geo_route_elevation
  end

  def speed
    render json: Activity.find(params[:id]).geo_route_speed
  end

  private

  def activity_params
    params.require(type.underscore.to_sym).permit(:type, :geo_route)
  end
end
