class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  field :started_at, type: Time
  field :completed_at, type: Time
  belongs_to :from_city, class_name: 'City', inverse_of: nil
  belongs_to :to_city, class_name: 'City', inverse_of: nil
  belongs_to :vehicle
  belongs_to :user

  def from_city_name
    from_city&.name
  end

  def from_city_name=(from_city_name)
    self.from_city = City.where(name: from_city_name).first
  end

  def to_city_name
    to_city&.name
  end

  def to_city_name=(to_city_name)
    self.to_city = City.where(name: to_city_name).first
  end

  def vehicle_reg_no
    self.vehicle&.reg_no
  end

  def user_name
    self.user&.name || self.user&.email
  end

  def book!(user)
    raise "User can not be blank" if user.blank?
    raise "from city is not found" if from_city.blank?
    raise "to city is not found" if to_city.blank?
    raise "from city status is blocked" if from_city.status == City::BLOCKED
    raise "to city status is blocked" if to_city.status == City::BLOCKED

    vehicle = Vehicle.where(status: Vehicle::IDLE, current_city_id: from_city.id).order(last_status_changed_at: :asc).first
    raise "no idle vehicle is found matching your requirement" if vehicle.blank?

    self.vehicle = vehicle
    self.user = user
    self.started_at = Time.now.utc
    self.save!

    vehicle.status = Vehicle::ON_TRIP
    vehicle.save!
  end

  def complete!
    raise "booking is already complete" if self.completed_at.present?
    self.completed_at = Time.now
    self.save!

    self.vehicle.status = Vehicle::IDLE
    self.vehicle.current_city = self.to_city
    self.vehicle.save!
  end
end
