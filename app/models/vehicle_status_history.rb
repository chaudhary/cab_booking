class VehicleStatusHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  MAX_ENDED_AT = Date.parse("2222-01-01").to_time

  field :status, type: String
  belongs_to :vehicle
  field :started_at, type: Time
  field :ended_at, type: Time

  def self.record(vehicle: , old_status:, new_status:)
    if old_status.present?
      VehicleStatusHistory.where(
        :vehicle_id => vehicle.id,
        :status => old_status,
        :ended_at.lt => Time.now
      ).update_all(ended_at: Time.now)
    end
    if new_status.present?
      VehicleStatusHistory.create!(
        vehicle_id: vehicle.id,
        status: new_status,
        started_at: Time.now,
        ended_at: MAX_ENDED_AT
      )
    end
  end

  def self.idle_time_in_hour(vehicle, start_time, end_time)
    VehicleStatusHistory.where(
      :vehicle_id => vehicle.id,
      :status => Vehicle::IDLE,
      :started_at.lt => end_time,
      :ended_at.gt => start_time
    ).map do |status_history|
      [status_history.ended_at, end_time].min - [status_history.started_at, start_time].max
    end.sum.to_f / 3600
  end

end
