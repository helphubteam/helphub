class HelpRequestKindPolicy < ApplicationPolicy
  def index?
    user.moderator?
  end

  def create?
    help_request_kind.organization == user.organization
  end

  def update?
    help_request_kind.organization == user.organization
  end

  def destroy?
    help_request_kind.organization == user.organization
  end

  class Scope < Scope
    def resolve
      return [] unless user.moderator?

      scope.where(organization: current_organization)
    end
  end

  private

  def help_request_kind
    record
  end
end
