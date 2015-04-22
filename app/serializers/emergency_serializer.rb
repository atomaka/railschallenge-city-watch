class EmergencySerializer < ActiveModel::Serializer
  attributes :code, :fire_severity, :police_severity, :medical_severity, :resolved_at, :responders, :full_response

  def responders
    object.responders.map(&:name)
  end
end
