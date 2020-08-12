class OrganizationPolicy < ApplicationPolicy
  def index?
    current_admin?
  end

  def create?
    current_admin?
  end

  def update?
    current_admin?
  end

  def destroy?
    current_admin?
  end

  def archive?
    current_admin?
  end

  private

  def current_admin?
    user.present? && user.admin?
  end

  def organization
    record
  end
end
