class CarsController < ApplicationController
  # before_action :authenticate_user!
  # include Pundit

  def index
    # @cars = policy_scope Car
    @cars = Car.all
    @markers = @cars.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude
        # info_window: render_to_string(partial: "info_window", locals: { car: car }),
        # image_url: helpers.asset_url("REPLACE_THIS_WITH_YOUR_IMAGE_IN_ASSETS")
      }
    end
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    @car.save ? redirect_to(car_path(@car)) : render(:new)
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path
  end

  private

  def car_params
    params.require(:car).permit(:address, :car_model, :color, :photo)
  end
end
