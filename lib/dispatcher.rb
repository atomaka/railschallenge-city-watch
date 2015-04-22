class Dispatcher
  def initialize(emergency)
    @emergency = emergency
  end

  def dispatch
    types.each do |type, severity|
      assign_responders(type)
    end
  end

  private

  def assign_responders(type)
    required_capacity = @emergency.send(types[type])
    available = Responder.available_on_duty(type).order(capacity: :desc)
    current_capacity = available.sum(:capacity)

    if(required_capacity == 0 || current_capacity == 0)
      return
    end

    available.each do |responder|
      if responder.capacity <= required_capacity
        if required_capacity <= 0
          break
        end
        @emergency.responders << responder
        required_capacity -= responder.capacity
      end
    end
  end

  def types
    {
      'Fire'    => :fire_severity,
      'Police'  => :police_severity,
      'Medical' => :medical_severity
    }
  end
end
