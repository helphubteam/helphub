# frozen_string_literal: true

class HelpRequestsSearcher < TextSearcher
  DEFAULT_SEARCH_PARAMS = {
    page: 1,
    overdue: false,
    search: '',
    column: 'updated_at',
    direction: 'desc',
    number: nil,
    creator_id: nil
  }.freeze

  SORT_COLUMN = %w[state created_at updated_at period].freeze

  attr_reader :search_params

  def initialize(search_params)
    @search_params = HashWithIndifferentAccess.new(DEFAULT_SEARCH_PARAMS).merge(
      search_params
    )
  end

  def call
    {
      base_scope: base_scope,
      paged_scope: paged_scope
    }
  end

  private

  def search_fields
    %i[id title comment phone person city street house district apartment score]
  end

  def base_scope
    scope = apply_search(HelpRequest)
    scope = apply_creator(scope)
    scope = apply_states(scope)
    scope = apply_number(scope)
    if search_params[:overdue]
      scope = apply_overdue(scope)
      sort = [:state, 'updated_at ASC']
    else
      sort = by_sorting_params
    end

    scope.reorder(sort)
  end

  def paged_scope
    base_scope.page(search_params[:page])
  end

  def apply_overdue(scope)
    overdue_timeout = 7.days.ago
    scope
      .where(state: %i[active assigned])
      .where('updated_at < ?', overdue_timeout)
  end

  def apply_states(scope)
    states = search_params[:states]
    states.blank? ? scope : scope.where(state: states)
  end

  def apply_creator(scope)
    creator_id = search_params[:creator_id]
    creator_id.blank? ? scope : scope.where(creator_id: creator_id)
  end

  def apply_number(scope)
    number = search_params[:number]
    number.blank? ? scope : scope.where("number ILIKE concat('%', ?, '%')", number)
  end

  def by_sorting_params
    ["#{search_params[:column]} #{search_params[:direction]}"]
  end
end
