# frozen_string_literal: true

class HelpRequestsSearcher
  SEARCH_FIELDS = %i[id comment phone person city street house district apartment].freeze

  DEFAULT_SEARCH_PARAMS = {
    limit: 100,
    overdue: false,
    search: ''
  }.freeze

  attr_reader :search_params

  def initialize(search_params)
    @search_params = HashWithIndifferentAccess.new(DEFAULT_SEARCH_PARAMS).merge(
      search_params
    )
  end

  def call
    scope = apply_search(HelpRequest)
    if search_params[:overdue]
      scope = apply_overdue(scope)
      sort = [:state, 'updated_at ASC']
    else
      sort = [:state, 'updated_at DESC']
    end

    scope
      .reorder(sort)
      .limit(search_params[:limit])
  end

  def apply_overdue(scope)
    overdue_timeout = 7.days.ago
    scope
      .where(state: %i[active assigned])
      .where('updated_at < ?', overdue_timeout)
  end

  def apply_search(scope)
    str = search_params[:search]
    return scope if str.blank?

    base_scope = scope.dup
    SEARCH_FIELDS.each_with_index do |field, index|
      query = "CAST(#{field} AS TEXT) ILIKE concat('%', ?, '%')"
      scope = if index.zero?
                scope.where(query, str)
              else
                scope.or(base_scope.where(query, str))
              end
    end
    scope
  end
end
