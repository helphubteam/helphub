# frozen_string_literal: true

class UsersSearcher
  SEARCH_FIELDS = %i[surname name phone email].freeze

  DEFAULT_SEARCH_PARAMS = {
    page: 1,
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
    scope = apply_search(User)
    scope.page(search_params[:page])
  end

  private

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
