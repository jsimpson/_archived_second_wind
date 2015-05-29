class ActivitiesController < ApplicationController
  before_action :set_type

  def index
    @activities = type_class.paginate(page: params[:page])
    @activities_in_last_year = type_class.offset(0).get_activites_for_period_of(1.year)
    @activities_in_last_month = type_class.offset(0).get_activites_for_period_of(1.month)
    @activities_in_last_week = type_class.offset(0).get_activites_for_period_of(1.week)
  end

  def show
    @activity = Activity.find(params[:id])
    @polyline = @activity.get_geo_points_lat_lng.to_json
  end

  def destroy
    @activity = Activity.find(params[:id])
    if @activity.destroy
      flash.now[:success] = 'Activity successfully deleted'
    end
    redirect_to activities_url
  end

  def analytics
    @by_day_of_week = type_class.analytics_by_day_of_week
    @by_month = type_class.analytics_by_month_of_year
  end

  def mileage
    render json: type_class.group_mileage_by_month
  end

  def heart_rate
    render json: type_class.find(params[:id]).get_geo_points_heart_rate
  end

  def elevation
    render json: type_class.find(params[:id]).get_geo_points_elevation
  end

  def speed
    render json: type_class.find(params[:id]).get_geo_points_speed
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
