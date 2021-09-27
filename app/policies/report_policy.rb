class ReportPolicy < ApplicationPolicy
  def index?
    user.moderator?
  end

  def create?
    report.organization == user.organization
  end

  def update?
    report.organization == user.organization
  end

  def destroy?
    report.organization == user.organization
  end

  class Scope < Scope
    def resolve
      return [] unless user.moderator?

      scope.where(organization: current_organization)
    end
  end

  private

  def report
    record
  end
end
