class CarsController < ApplicationController
  # before_action :authenticate_user!
  # include Pundit
  before_action :find_car, only: %i[destroy show update edit]
  before_action :car_bookings, only: %i[edit show]

  def index
    if params[:query].present?
      # sql_query = "car_model ILIKE :query OR address ILIKE :query"
      # @cars = Car.where(sql_query, query: "%#{params[:query]}%")
      car_ids = query_search_ids(params)
      @cars = Car.where(id: car_ids)
    else
      @cars = Car.all
    end
    @markers = @cars.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        info_window: render_to_string(partial: "info_window", locals: { car: car })
      }
    end
  end

  def show; end

  def edit
    @markers = [{ lat: @car.latitude, lng: @car.longitude }]
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
    request.path == dashboard_path ? (render :index) : (redirect_to dashboard_path)
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

  def query_search_ids(params)
    split_query_array = params[:query].split
    car_ids = search_by_address_or_model(split_query_array)
    return car_ids
  end

  def search_by_address_or_model(split_query_array)
    sql_query_car_model = "car_model ILIKE :query"
    sql_query_address = "address ILIKE :query"
    car_ids = []
    split_query_array.each do |word|
      car_model_ids = Car.where(sql_query_car_model, query: "%#{word}%").map(&:id)
      car_address_ids = Car.where(sql_query_address, query: "%#{word}%").map(&:id)
      car_near_ids = Car.near(word).map(&:id)
      car_ids += [car_model_ids, car_address_ids, car_near_ids].flatten.compact.uniq
    end
    return car_ids
  end
end
