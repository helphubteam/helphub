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

  private

  def set_user
    record
  end
end
