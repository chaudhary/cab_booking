json.extract! vehicle, :id, :reg_no, :status, :current_city_id, :last_status_changed_at, :driver_name, :driver_email, :driver_mobile, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
