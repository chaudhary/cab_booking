class Vehicle
  include Mongoid::Document
  include Mongoid::Timestamps

  ON_TRIP = 'On Trip'
  IDLE = 'Idle'
  BLOCKED = 'Blocked'
  ON_REST = 'On Rest'

  ALL_STATUSES = [
    ON_TRIP,
    IDLE,
    BLOCKED,
    ON_REST
  ]

  field :reg_no, type: String
  field :status, type: String
  field :last_status_changed_at, type: Time
  field :driver_name, type: String
  field :driver_email, type: String
  field :driver_mobile, type: String
  belongs_to :current_city, class_name: 'City', inverse_of: nil

  before_save do |doc|
    if doc.status_changed?
      doc.last_status_changed_at = Time.now
    end
  end

  def current_city_name
    return "indeterminate" if self.status == ON_TRIP
    current_city&.name
  end

  def current_city_name=(current_city_name)
    self.current_city = City.where(name: current_city_name).first
  end
end
