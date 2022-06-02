class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @car = Car.find(params[:car_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.car = Car.find(params[:car_id])
    @booking.user = current_user
    @booking.status = "pending"
    @booking.save ? (redirect_to cars_path) : (render :new)
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to dashboard_path
  end

  def index; end

  def update
    @booking = Booking.find(params[:id])
    if params[:name] == "accept"
      @booking.status = "accepted"
      @booking.save!
    else
      @booking.destroy
    end
    redirect_to dashboard_path
  end

  private

  def booking_params
    params.require(:booking).permit(:start_time, :end_time)
  end
end
