# frozen_string_literal: true

class UserPresenter < BasePresenter
  def call
    super.merge({
                  role: target.role,
                  email: target.email,
                  created_at: target.created_at.to_i,
                  updated_at: target.updated_at.to_i
                })
  end
end
