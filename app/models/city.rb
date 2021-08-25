class City
  include Mongoid::Document
  include Mongoid::Timestamps

  ACTIVE = 'active'
  BLOCKED = 'blocked'

  ALL_STATUSES = [
    ACTIVE,
    BLOCKED
  ]

  field :name, type: String
  field :status, type: String
end
