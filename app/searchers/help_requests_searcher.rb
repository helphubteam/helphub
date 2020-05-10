# frozen_string_literal: true

class HelpRequestsSearcher < BaseSearcher
  SEARCH_PARAMS = %i[limit sort].freeze

  def call
    HelpRequest.
      limit(search_params[:limit]).
      reorder(search_params[:sort])
  end
end
