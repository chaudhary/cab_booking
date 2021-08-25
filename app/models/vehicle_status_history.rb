class VehicleStatusHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :status, type: String
  belongs_to :vehicle
  field :started_at, type: Time
  field :ended_at, type: Time

  def self.record(vehicle: , old_status:, new_status:)
    if old_status.present?
      VehicleStatusHistory.where(
        vehicle_id: vehicle.id,
        status: old_status,
        ended_at: nil
      ).update_all(end_at: Time.now)
    end
    if new_status.present?
      VehicleStatusHistory.create!(
        vehicle_id: vehicle.id,
        status: new_status,
        started_at: Time.now
      )
    end
  end
end
