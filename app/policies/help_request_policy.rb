class HelpRequestPolicy < ApplicationPolicy
  def index?
    user.moderator?
  end

  def create?
    help_request.organization == user.organization
  end

  def clone?
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
      return [] unless user.moderator?

      scope.where(organization: current_organization)
    end
  end

  private

  def help_request
    record
  end
end
