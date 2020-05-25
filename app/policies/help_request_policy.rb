class HelpRequestPolicy < ApplicationPolicy
  def index?
    false if user.admin?
  end

  def create?
    help_request.organization == user.organization
  end

  def update?
    help_request.organization == user.organization || user.admin?
  end

  def destroy?
    help_request.organization == user.organization || user.admin?
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

  def help_request
    record
  end
end
