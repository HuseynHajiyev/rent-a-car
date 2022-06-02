class CarsController < ApplicationController
  # before_action :authenticate_user!
  # include Pundit
  before_action :find_car, only: %i[destroy show update edit]
  before_action :car_bookings, only: %i[edit show]

  def index
    @cars = Car.where.not(user: current_user)
    @markers = @cars.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude
      }
    end
  end

  def show; end

  def edit
    @markers = { lat: @car.latitude, lng: @car.longitude }
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    @car.save ? redirect_to(car_path(@car)) : render(:new)
  end

  def update
    @params = update_car_params
    @car.address = @params[:address].nil? ? @car.address : @params[:address]
    @car.color = @params[:color].nil? ? @car.color : @params[:color]
    @car.price = @params[:price].nil? ? @car.price : @params[:price]
    @car.save ? redirect_to(car_path(@car)) : render(:new)
  end

  def destroy
    @car.destroy
    redirect_to cars_path
  end

  private

  def car_params
    params.require(:car).permit(:address, :car_model, :color, :price, :photo)
  end

  def update_car_params
    params.require(:car).permit(:address, :color, :price, :photo)
  end

  def find_car
    @car = Car.find(params[:id])
  end

  def car_bookings
    @bookings = Booking.find_by(car: @car)
  end
end
