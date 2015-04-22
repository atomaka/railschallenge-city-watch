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
      Responder.total(type).sum(:capacity),
      Responder.available(type).sum(:capacity),
      Responder.on_duty(type).sum(:capacity),
      Responder.available_on_duty(type).sum(:capacity)
    ]
  end
end
