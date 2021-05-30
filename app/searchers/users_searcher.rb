# frozen_string_literal: true

class UsersSearcher < TextSearcher
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
    {
      base_scope: base_scope,
      paged_scope: paged_scope
    }
  end

  private

  def search_fields
    %i[surname name phone email]
  end

  def base_scope
    apply_search(User).reorder('status DESC, updated_at DESC')
  end

  def paged_scope
    base_scope.page(search_params[:page])
  end
end
