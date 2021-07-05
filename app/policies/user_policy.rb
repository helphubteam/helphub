class UserPolicy < ApplicationPolicy
  def create?
    user.admin? || (user.moderator? && !set_user.admin?)
  end

  def update?
    user.admin? || (user.moderator? && !set_user.admin?)
  end

  def destroy?
    user.admin? || user.moderator?
  end

  def approve?
    user.admin? || (user.moderator? && !set_user.admin?)
  end

  class Scope < Scope
    def resolve
      return scope if user.admin?

      scope.where(organization: current_organization)
    end
  end

  private

  def set_user
    record
  end
end
