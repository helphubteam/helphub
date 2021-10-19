class CustomValuePolicy < ApplicationPolicy
  def index?
    user.moderator? || user.content_manager?
  end

  def create?
    help_request.organization == user.organization
  end

  def update?
    help_request.organization == user.organization
  end

  def destroy?
    help_request.organization == user.organization
  end

  class Scope < Scope
    def resolve
      return [] if !user.moderator? && !user.content_manager? 

      scope.includes(:help_request).where(help_request: { organization: current_organization })
    end
  end

  private

  def help_request
    record.help_request
  end
end
