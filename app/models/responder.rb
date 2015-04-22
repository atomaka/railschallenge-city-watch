class Responder < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  validates :name,     uniqueness: true,
                       presence: true
  validates :capacity, presence: true,
                       inclusion: { in: 1..5 }
  validates :type,     presence: true

  belongs_to :emergency, foreign_key: :code, primary_key: :emergency_code

  scope :total, ->(type) { where(type: type) }
  scope :available, ->(type) { where(type: type, emergency_code: nil) }
  scope :on_duty, ->(type) { where(type: type, on_duty: true) }
  scope :available_on_duty, ->(type) { where(type: type, emergency_code: nil, on_duty: true) }
  scope :by_capacity, ->() { order(capacity: :desc) }
  scope :capacity_sum, -> () { sum(:capacity) }

  def self.types
    {
      'Fire'    => :fire_severity,
      'Police'  => :police_severity,
      'Medical' => :medical_severity
    }
  end
end
