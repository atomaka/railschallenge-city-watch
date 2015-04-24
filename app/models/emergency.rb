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

  def complete_response
    update(full_response: true)
  end

  def capacity_met?
    total_responder_count >= total_required_capacity
  end

  def total_responder_count
    responders.sum(:capacity)
  end

  def total_required_capacity
    Responder.types.values.map { |value| send(value) }.sum || 0
  end

  def responder_count(type)
    responders.select { |r| r.type == type }.map(&:capacity).sum
  end

  def required_capacity(type)
    send(Responder.types[type])
  end

  def current_required_capacity(type)
    send(Responder.types[type]) - responder_count(type)
  end

  def responder_too_large?(type, responder)
    responder.capacity > current_required_capacity(type)
  end

  def responders_needed?(type)
    current_required_capacity(type) > 0
  end

  def resolve
    responders.clear if resolved_at_changed?
  end

  def add_responder(responder)
    responders << responder unless responders.include?(responder)
  end

  def self.stats
    [full_response.count, all.count]
  end
end
