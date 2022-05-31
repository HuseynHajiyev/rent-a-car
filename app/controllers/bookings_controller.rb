class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @car = Car.find(params[:car_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.car = Car.find(params[:car_id])
    @booking.user = current_user
    #@booking.save ? (redirect_to cars_path) : (render :new)
    @booking.save!
    redirect_to cars_path
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
