class ReportPolicy < ApplicationPolicy
  def index?
    !user.admin?
  end

  def create?
    puts report.attributes.inspect
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
      if user.admin?
        []
      else
        scope.where(organization: current_organization)
      end
    end
  end

  private

  def report; record; end
end
