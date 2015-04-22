class Emergency < ActiveRecord::Base
  validates :code,             presence: true,
                               uniqueness: true
  validates :fire_severity,    presence: true,
                               numericality: { greater_than_or_equal_to: 0 }
  validates :police_severity,  presence: true,
                               numericality: { greater_than_or_equal_to: 0 }
  validates :medical_severity, presence: true,
                               numericality: { greater_than_or_equal_to: 0 }

  has_many :responders, foreign_key: :emergency_code, primary_key: :code

  scope :full_response, ->() { where(full_response: true) }

  after_update :resolve

  def capacity_met?
    responder_count >= required_capacity
  end

  def responder_count
    responders.sum(:capacity)
  end

  def required_capacity
    types.values.map { |value| send(value) }.sum || 0
  end

  def types
    {
      'Fire'    => :fire_severity,
      'Police'  => :police_severity,
      'Medical' => :medical_severity
    }
  end

  def resolve
    responders.clear if resolved_at_changed?
  end

  def self.stats
    [full_response.count, all.count]
  end
end
