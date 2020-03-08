# frozen_string_literal: true

class BaseSearcher
  DEFAULT_SEARCH_PARAMS = {
    limit: 10,
    sort: 'created_at DESC'
  }.freeze

  attr_reader :search_params

  def initialize(search_params)
    @search_params = HashWithIndifferentAccess.new(DEFAULT_SEARCH_PARAMS).merge(
      search_params
    )
  end

  protected

  def apply_sort(scope, value)
    scope.reorder(value)
  end

  def apply_limit(scope, value)
    scope.limit(value.to_i)
  end
end
