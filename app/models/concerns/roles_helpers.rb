require 'active_support/concern'

module RolesHelpers
  extend ActiveSupport::Concern

  MODERATOR = 'moderator'.freeze
  ADMIN = 'admin'.freeze
  VOLUNTEER = 'volunteer'.freeze
  CONTENT_MANAGER = 'content_manager'.freeze

  ROLES = [ADMIN, MODERATOR, VOLUNTEER, CONTENT_MANAGER].freeze

  included do
    ROLES.each do |role|
      define_method("#{role}?") do
        self.roles ||= {}
        self.roles[role].to_s == 'true'
      end

      define_method("#{role}=") do |value|
        self.roles ||= {}
        self.roles[role] = value
      end

      define_method(role.to_s) do
        self.roles ||= {}
        self.roles[role] == 'true'
      end

      scope role.pluralize, -> { by_role(role) }
    end

    def role
      return ADMIN if admin?
      return MODERATOR if moderator?
      return CONTENT_MANAGER if content_manager?

      VOLUNTEER
    end

    def role=(role)
      role_str = role.to_s
      raise 'Wrong role name' unless ROLES.include?(role_str)

      self.roles = {} unless roles
      self.admin = true if role.to_s == ADMIN
      self.moderator = true if role.to_s == MODERATOR
      self.volunteer = true if role.to_s == VOLUNTEER
      self.volunteer = true if role.to_s == CONTENT_MANAGER
    end

    scope :by_role, ->(role) { where("roles -> ? = 'true'", role) }
  end
end
