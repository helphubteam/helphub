class UserPolicy < ApplicationPolicy
  def create?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      user.moderator? && !set_user.admin?
    )
  end

  def update?
    return true if user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      (
        (user.moderator? && !set_user.admin?) || 
        (user.content_manager? && set_user == user)
      )
    )
    false
  end

  def destroy?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      user.moderator? && !set_user.admin?
    )
  end

  def approve?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      user.moderator? && !set_user.admin?
    )
  end

  def update_admin_role?
    user.admin?
  end

  def update_moderator_role?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      user.moderator?
    )
  end

  def update_volunteer_role?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      (
        user.moderator? || (
          set_user == user && user.content_manager?
        )
      )
    )
  end

  def update_content_manager_role?
    user.admin? || (
      (user.organization_id == set_user.organization_id) &&
      (
        user.moderator? || (
          set_user == user && user.content_manager?
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
end
