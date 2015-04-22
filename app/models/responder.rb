class Responder < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  validates :name,     uniqueness: true,
                       presence: true
  validates :capacity, presence: true,
                       inclusion: { in: 1..5 }
  validates :type,     presence: true

  belongs_to :emergency, foreign_key: :code, primary_key: :emergency_code

  scope :total_responders, ->(type) { where(type: type).sum(:capacity) }
  scope :unavailable_responders, ->(type) { where(type: type, emergency_code: nil).sum(:capacity) }
  scope :on_duty_responders, ->(type) { where(type: type, on_duty: true).sum(:capacity) }
  scope :available_responders, ->(type) { where(type: type, emergency_code: nil, on_duty: true).sum(:capacity) }
end
