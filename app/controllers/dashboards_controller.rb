class DashboardsController < ApplicationController
  before_action :car_bookings

  def index
    @bookings = Booking.where(user: current_user)
    @cars = Car.where(user: current_user)
    @pending_bookings = Booking.select do |booking|
      # booking.status == "pending" &&
      booking.car.user == current_user
    end
    @accepted_bookings = Booking.select { |booking| booking.status == "accepted" && booking.car.user == current_user }
  end

  private

  def car_bookings
    @bookings = Booking.find_by(car: @car)
  end
end
