class Dispatcher
  def initialize(emergency)
    @emergency = emergency
  end

  def dispatch
    Responder.types.keys.each do |type|
      assign_responders(type)
    end

    @emergency.complete_response if @emergency.capacity_met?
  end

  private

  def assign_responders(type)
    available = Responder.sorted_available_on_duty(type)

    return unless @emergency.responders_needed?(type)
    return unless responders?(available)

    available.each do |responder|
      break unless @emergency.responders_needed?(type)
      next if @emergency.responder_too_large?(type, responder)

      @emergency.add_responder(responder)
    end

    # Emergency#add_responder prevents duplicates
    @emergency.add_responder(available.last) if @emergency.responders_needed?(type)
  end

  def responders?(available)
    available.size > 0
  end
end
