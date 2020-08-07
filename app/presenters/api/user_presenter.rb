# frozen_string_literal: true

module Api
  class UserPresenter < BasePresenter
    def call
      super.merge({
                    role: target.role,
                    organization: target.organization.title,
                    name: target.name,
                    surname: target.surname,
                    phone: target.phone,
                    email: target.email,
                    score: target.score,
                    created_at: target.created_at.to_i,
                    updated_at: target.updated_at.try(:to_i)
                  })
    end
  end
end
