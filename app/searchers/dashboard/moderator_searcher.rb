# frozen_string_literal: true

module Dashboard
  class ModeratorSearcher
    def initialize(user)
      @user = user
      @organization = user.organization
    end

    def call
      {

      }
    end

    private

    attr_reader :user, :organization
  end
end
