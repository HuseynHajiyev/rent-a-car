class BookingsController < ApplicationController
  def new
    @booking = Booking.new
  end

  def create
    @booking = booking.new(booking_params)
    @booking.user = current_user
    @booking.save ? redirect_to(booking_path(@booking)) : render(:new)
  end

  private

  def booking_params
    params.require(:booking).permit(:booking_model, :color)
  end
end
