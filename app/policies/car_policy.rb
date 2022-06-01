class CarPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      # Name of the class is replaced by scope
      # scope.where(role: 'Assitant')
      # Restaurnt.where(.....)
      # Restaurant.all
      scope.all
    end
  end

  def create?
    return true
  end

  def index?
    true
  end
end
