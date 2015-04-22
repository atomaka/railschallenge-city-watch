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
    available = sorted_available_on_duty(type)
    current_capacity = available.capacity_sum

    return if assign_responders?(required_capacity, current_capacity)

    available.each do |responder|
      break unless responders_needed(required_capacity)
      next if responder_too_large(responder, required_capacity)

      add_responder(responder)
      available.delete(responder)
      required_capacity -= responder.capacity
    end

    add_responder(available.last) if responders_needed(required_capacity)
  end

  private

  def sorted_available_on_duty(type)
    Responder.available_on_duty(type).by_capacity
  end

  def responder_too_large(responder, required)
    responder.capacity > required
  end

  def responders_needed(required)
    required > 0
  end

  def assign_responders?(required, current)
    required == 0 || current == 0
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
