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
    car_ids = search_ids_by_address_or_model(split_query_array)
    return car_ids
  end

  def search_ids_by_address_or_model(split_query_array)
    sql_query_car_model = "car_model ILIKE :query"
    sql_query_address = "address ILIKE :query"
    car_ids = []
    car_models = []
    car_addresses = []
    split_query_array.each do |word|
      Car.where(sql_query_car_model, query: "%#{word}%").each { |car| car_models << car.car_model }
    end
    location_name_from_query = split_query_array.reject { |word| car_models.include?(word.downcase) }.join(" ")
    return Car.near(location_name_from_query).map(&:id) if car_models.empty?

    car_ids += proximity_search(car_models, car_addresses, split_query_array).flatten.compact.uniq
    return car_ids
  end

  def proximity_search(car_models, car_addresses, words)
    relevant_car_ids = []
    sql_query_car_model = "car_model ILIKE :query"
    regex = /.*#{words[0]}.*/
    model_name_from_query = car_models.map(&:downcase).select { |car| regex.match?(car) }.uniq.join(" ")
    location_name_from_query = words.reject { |word| car_models.map(&:downcase).include?(word.downcase) }.join(" ")
    proximity_result = Car.near(location_name_from_query)
    if !car_models.empty? && !proximity_result.empty? # there is an address and model name
      relevant_car_ids += Car.near(location_name_from_query).select { |car| car_models.include?(car.car_model.downcase) }.map(&:id)
    elsif !car_models.empty? && proximity_result.empty? # there is no address but there is a model name
      relevant_car_ids += Car.where(sql_query_car_model, query: "%#{model_name_from_query}%").map(&:id)
    elsif car_models.empty? && !proximity_result.empty? # there is an address but there is no model name
      relevant_car_ids += Car.near(location_name_from_query).map(&:id)
    else
      car_by_location = Car.near(location_name_from_query)
      car_by_location = car_by_location.select { |car| car_models.include?(car.car_model.downcase) }
      relevant_car_ids += car_by_location.map(&:id)
    end
    return relevant_car_ids
  end
end
