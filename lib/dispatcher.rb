class Dispatcher
  def initialize(emergency)
    @emergency = emergency
  end

  def dispatch
    Responder.types.keys.each do |type|
      assign_responders(type)
    end

    set_full_response if @emergency.capacity_met?
  end

  private

  def assign_responders(type)
    required_capacity = capacity(type)
    available = Responder.available_on_duty(type).by_capacity
    current_capacity = available.capacity_sum

    return if required_capacity == 0 || current_capacity == 0

    available.each do |responder|
      break if required_capacity == 0
      next unless responder.capacity <= required_capacity

      add_responder(responder)
      available.delete(responder)
      required_capacity -= responder.capacity
    end

    @emergency.responders << available.last if required_capacity > 0
  end

  def set_full_response
    @emergency.full_response = true
    @emergency.save
  end

  def add_responder(responder)
    @emergency.responders << responder
  end

  def capacity(type)
    @emergency.send(Responder.types[type])
  end
end
