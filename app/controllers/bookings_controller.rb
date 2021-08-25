class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
    @bookings = @bookings.where(user_id: current_user.id) unless current_user.is_admin
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)
    begin
      @booking.book!(current_user)
      redirect_to bookings_path, notice: "Booking was successfully created."
    rescue Exception => ex
      redirect_to bookings_path, flash: { error: ex.message }
    end
  end

  def complete
    booking = Booking.where(user_id: current_user.id, :_id => params[:id]).first
    begin
      booking.complete!
      redirect_to bookings_path, notice: "Booking was successfully completed."
    rescue Exception => ex
      redirect_to bookings_path, flash: { error: ex.message }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:from_city_name, :to_city_name)
    end
end
