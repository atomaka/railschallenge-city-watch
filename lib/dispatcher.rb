class Dispatcher
  def initialize(emergency)
    @emergency = emergency
  end

  def dispatch
    types.each do |type, severity|
      assign_responders(type)
    end
    if @emergency.capacity_met?
      @emergency.full_response = true
      @emergency.save
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
      if required_capacity == 0
        break
      end
      if responder.capacity <= required_capacity
        @emergency.responders << responder
        available.delete(responder)
        required_capacity -= responder.capacity
      end
    end

    if required_capacity > 0
      @emergency.responders << available.last
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
