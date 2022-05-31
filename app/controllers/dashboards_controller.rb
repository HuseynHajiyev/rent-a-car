class DashboardsController < ApplicationController
  def index
    @bookings = Booking.where(user: current_user)
  end
end
