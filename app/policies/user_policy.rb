class UserPolicy < ApplicationPolicy
  def create?
    user.admin? || (user.moderator? && !set_user.admin?)
  end

  def update?
    return true if user.admin? || (
      user.moderator? && !set_user.admin? 
    ) || (
      user.content_manager? && set_user == user
    )
    false
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
      return scope.where(id: user.id) if user.content_manager?

      scope.where(organization: current_organization)
    end
  end

  private

  def set_user
    record
  end
end
