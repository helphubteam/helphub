# frozen_string_literal: true

class HelpRequestsSearcher < BaseSearcher
  SEARCH_PARAMS = %i[limit sort lonlat].freeze

  def call
    scope = HelpRequest.limit(search_params[:limit] || 10)
    scope = near_order(scope)
    scope
  end

  private

  def near_order(scope)
    return scope unless search_params[:lonlat]
    long, lat = search_params[:lonlat].split('_').map(&:to_f)
    order_query = "ST_Distance(help_requests.lonlat, ST_GeogFromText('SRID=4326;POINT(#{long} #{lat})')) ASC"
    scope.reorder(order_query)
  end
end
