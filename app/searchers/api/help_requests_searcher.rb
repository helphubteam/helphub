# frozen_string_literal: true

module Api
  class HelpRequestsSearcher
    DEFAULT_SEARCH_PARAMS = {
      limit: 100,
      offset: 0,
      lonlat: nil,
      sort: 'created_at DESC',
      taken: false,
      submitted: false,
      distance: 400
    }.freeze

    attr_reader :search_params, :current_api_user

    def initialize(search_params, current_api_user)
      @search_params = HashWithIndifferentAccess.new(DEFAULT_SEARCH_PARAMS).merge(
        search_params
      )
      @current_api_user = current_api_user
    end

    def call
      scope = HelpRequest.preload(:custom_values, :custom_fields, :creator)
      return submitted_scope(scope) if search_params[:submitted] == 'true'
      return taken_scope(scope) if search_params[:taken] == 'true'

      map_scope(scope)
    end

    private

    def map_scope(scope)
      scope
        .where(state: %i[active assigned],
               organization: current_organization)
        .yield_self(&method(:apply_limit))
        .yield_self(&method(:apply_offset))
        .yield_self(&method(:apply_sort))
        .yield_self(&method(:apply_lonlat))
        .yield_self(&method(:apply_distance))
    end

    def taken_scope(scope)
      scope
        .assigned
        .where(volunteer: current_api_user,
               # не обязательный параметр выборки, в любом случаи будет проверка по волонтеру(который принадл организации)
               organization: current_organization)
        .yield_self(&method(:apply_sort))
        .yield_self(&method(:apply_limit))
        .yield_self(&method(:apply_offset))
        .yield_self(&method(:apply_distance))
    end

    def submitted_scope(scope)
      submitted_help_request_ids = current_api_user.activity.where(kind: :submitted).pluck(:help_request_id)
      scope
        .submitted
        .where(id: submitted_help_request_ids)
        .yield_self(&method(:apply_sort))
        .yield_self(&method(:apply_limit))
        .yield_self(&method(:apply_offset))
    end

    def apply_limit(scope)
      scope.limit(search_params[:limit])
    end

    def apply_offset(scope)
      scope.offset(search_params[:offset])
    end

    def apply_sort(scope)
      scope.reorder(search_params[:sort])
    end

    def apply_lonlat(scope)
      return scope unless search_params[:lonlat]

      # temporary solution, was necessarry to swap coordinates because of mistake with its order. Client need to receive
      # data with previous wrong order.
      # long, lat = search_params[:lonlat].split('_').map(&:to_f)
      lat, long = search_params[:lonlat].split('_').map(&:to_f)
      distance_query = "ST_Distance(help_requests.lonlat, ST_GeogFromText('SRID=4326;POINT(#{long} #{lat})'))"
      distance_order_query = "#{distance_query} ASC"
      distance_limit_query = "#{distance_query} < #{(search_params[:distance].to_i * 1000)}"
      distance_limit_sql = Arel.sql(distance_limit_query)
      distance_order_sql = Arel.sql(distance_order_query)
      scope.where(distance_limit_sql).reorder(distance_order_sql)
    end

    def apply_distance(scope)
      return scope unless search_params[:lonlat]

      # temporary solution, was necessarry to swap coordinates because of mistake with its order. Client need to receive
      # data with previous wrong order.
      # long, lat = search_params[:lonlat].split('_').map(&:to_f)
      lat, long = search_params[:lonlat].split('_').map(&:to_f)
      distance_query = "ST_Distance(help_requests.lonlat, ST_GeogFromText('SRID=4326;POINT(#{long} #{lat})'))"
      select_distance_sql = Arel.sql("help_requests.*, #{distance_query} as distance")
      group_sql = Arel.sql('help_requests.id')
      scope.select(select_distance_sql).group(group_sql).all
    end

    def current_organization
      current_api_user.organization
    end
  end
end
