require 'active_support/concern'

module RolesHelpers
  extend ActiveSupport::Concern

  MODERATOR = 'moderator'.freeze
  ADMIN = 'admin'.freeze
  VOLUNTEER = 'volunteer'.freeze

  ROLES = [ADMIN, MODERATOR, VOLUNTEER].freeze

  included do
    ROLES.each do |role|
      define_method("#{role}?") do
        roles[role].to_s == 'true'
      end

      define_method("#{role}=") do |value|
        roles[role] = value
      end

      define_method(role.to_s) do
        roles[role] == 'true'
      end

      scope role.pluralize, -> { by_role(role) }
    end

    def role
      return ADMIN if admin?
      return MODERATOR if moderator?

      VOLUNTEER
    end

    def role=(role)
      role_str = role.to_s
      raise 'Wrong role name' unless ROLES.include?(role_str)

      self.roles = {} unless roles
      self.admin = true if role.to_s == ADMIN
      self.moderator = true if role.to_s == MODERATOR
      self.volunteer = true if role.to_s == VOLUNTEER
    end

    scope :by_role, ->(role) { where("roles -> ? = 'true'", role) }
  end
end
