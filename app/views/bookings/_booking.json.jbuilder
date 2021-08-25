json.extract! booking, :id, :from_city_name, :to_city_name, :vehicle_id, :user_id, :started_at, :completed_at, :created_at, :updated_at
json.url booking_url(booking, format: :json)
