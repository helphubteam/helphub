class HelpRequestPolicy < ApplicationPolicy
  def create?
    help_request.organization == user.organization
  end

  def update?
    help_request.organization == user.organization || user.admin?
  end

  def destroy?
    help_request.organization == user.organization || user.admin?
  end

  private

  def help_request
    record
  end
end
