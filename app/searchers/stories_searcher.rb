# frozen_string_literal: true

class StoriesSearcher < BaseSearcher
  SEARCH_PARAMS = %i[limit sort query].freeze

  def call
    scope = Story.preload(:articles)
    SEARCH_PARAMS.each do |key|
      value = search_params[key]
      scope = send("apply_#{key}", scope, value) if value.present?
    end
    scope
  end

  private

  def apply_query(scope, value)
    scope.where("name ILIKE concat('%', ?, '%')", value)
  end
end
