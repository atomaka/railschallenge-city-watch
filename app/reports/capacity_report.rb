class CapacityReport
  def self.generate
    {
      'capacity': {
        'Fire': capacity('Fire'),
        'Police': capacity('Police'),
        'Medical': capacity('Medical')
      }
    }
  end

  def self.capacity(type)
    [
      Responder.total_responders(type),
      Responder.unavailable_responders(type),
      Responder.on_duty_responders(type),
      Responder.available_responders(type)
    ]
  end
end
