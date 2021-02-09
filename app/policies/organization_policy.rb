class OrganizationPolicy < ApplicationPolicy
  def index?
    current_admin?
  end

  def create?
    current_admin?
  end

  def update?
    current_admin? || (current_moderator? && organization.changes.keys == ['config'])
  end

  def destroy?
    current_admin?
  end

  def archive?
    current_admin?
  end

  def show?
    current_admin? || current_moderator?
  end

  private

  def current_admin?
    user.present? && user.admin?
  end

  def current_moderator?
    user.present? && user.moderator? && user.organization == organization
  end

  def organization
    record
  end
end
