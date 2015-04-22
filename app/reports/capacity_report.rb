class CapacityReport
  def self.generate
    capacity = {}
    Responder.types.keys.each do |type|
      capacity[type] = capacity(type)
    end

    { 'capacity': capacity }
  end

  def self.capacity(type)
    [
      Responder.total(type).capacity_sum,
      Responder.available(type).capacity_sum,
      Responder.on_duty(type).capacity_sum,
      Responder.available_on_duty(type).capacity_sum
    ]
  end
end
