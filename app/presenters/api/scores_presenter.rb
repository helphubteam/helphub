# frozen_string_literal: true

module Api
  class ScoresPresenter < BasePresenter
    def call
      return [] unless target.organization

      users_data.map do |(email, score, name, surname, id)|
        {
          id: id,
          score: score,
          email: email,
          name: name,
          surname: surname
        }
      end
    end

    private

    def users_data
      target.organization.users.reorder('score DESC').pluck(:email, :score, :name, :surname, :id)
    end
  end
end
