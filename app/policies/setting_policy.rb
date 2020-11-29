class SettingPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    false
  end

  def update?
    user.admin?
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      return [] unless user.admin?

      scope
    end
  end
end
