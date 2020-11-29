class CustomFieldPolicy < ApplicationPolicy
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

      scope.includes(:help_request_kind).where(help_request_kinds: { organization: current_organization })
    end
  end

  private

  def help_request_kind
    record.help_request_kind
  end
end
