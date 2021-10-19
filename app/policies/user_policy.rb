class UserPolicy < ApplicationPolicy
  def create?
    user.admin? || (
      own_organization? && user.moderator? && !set_user.admin?
    )
  end

  def update?
    return true if user.admin? || (
      own_organization? &&
      (
        (user.moderator? && !set_user.admin?) || 
        (user.content_manager? && setup_own_user?)
      )
    )
    false
  end

  def destroy?
    user.admin? || (
      own_organization? &&
      user.moderator? && !set_user.admin?
    )
  end

  def approve?
    user.admin? || (
      own_organization? &&
      user.moderator? && !set_user.admin?
    )
  end

  def update_admin_role?
    user.admin?
  end

  def update_moderator_role?
    user.admin? || (
      own_organization? &&
      user.moderator?
    )
  end

  def update_volunteer_role?
    user.admin? || (
      own_organization? &&
      (
        user.moderator? || (
          setup_own_user? && user.content_manager?
        )
      )
    )
  end

  def update_content_manager_role?
    user.admin? || (
      (own_organization?) &&
      (
        user.moderator? || (
          setup_own_user? && user.content_manager?
        )
      )
    )
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

  def own_organization?
    user.organization_id == set_user.organization_id
  end

  def setup_own_user?
    set_user == user
  end
end
