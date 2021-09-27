class HelpRequestPolicy < ApplicationPolicy
  def index?
    user.moderator? || user.content_manager? 
  end

  def create?
    help_request.organization == user.organization
  end

  def clone?
    standard_access(user, help_request)
  end

  def update?
    standard_access(user, help_request)
  end

  def destroy?
    standard_access(user, help_request)
  end

  class Scope < Scope
    def resolve
      if user.moderator?
        return scope.where(organization: current_organization)
      elsif user.content_manager?
        return scope.where(
          organization: current_organization,
          creator_id: user.id
        )
      else
        []
      end
    end
  end

  private

  def standard_access(user, help_request)
    return true if user.admin?
    return help_request.organization == user.organization if user.moderator?
    return help_request.creator_id == user.id if user.content_manager?
    false
  end

  def help_request
    record
  end
end
