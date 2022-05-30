class CarsController < ApplicationController
  def index
    @cars = Car.all
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
    @car.save ? render(car_path(@car)) : render(:new)
  end

  private

  def car_params
    params.require(:car).permit(:car_model, :color)
  end
end
