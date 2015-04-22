class Responder < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  validates :name,     uniqueness: true,
                       presence: true
  validates :capacity, presence: true,
                       inclusion: { in: 1..5 }
  validates :type,     presence: true

  belongs_to :emergency

  def emergency_code
    nil
  end
end
