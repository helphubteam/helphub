# frozen_string_literal: true

class StoriesSearcher < BaseSearcher
  SEARCH_PARAMS = %i[limit sort name].freeze

  def call
    scope = Story.preload(:articles)
    SEARCH_PARAMS.each do |key|
      value = search_params[key]
      scope = send("apply_#{key}", scope, value) if value.present?
    end
    scope
  end

  private

  def apply_name(scope, value)
    ilike_scope(scope, :name, value)
  end
end
