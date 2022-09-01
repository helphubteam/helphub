# frozen_string_literal: true

module Api
  module V3
    class HelpRequestsController < Api::V1::BaseController
      before_action :fill_help_request, only: %i[assign submit refuse]

      def index
        records = Api::HelpRequestsSearcher.new(
          permitted_params, current_api_user
        ).call

        response = records.map do |record|
          Api::V3::HelpRequestPresenter.new(record, current_api_user).call
        end
        render json: response
      end

      def assign
        data = Api::V3::HelpRequestCases::Assign.new({
                                                       help_request: @help_request,
                                                       volunteer: current_api_user,
                                                       params: update_params
                                                     }).call
        render_data(data)
      end

      def submit
        data = Api::V3::HelpRequestCases::Submit.new({
                                                       help_request: @help_request,
                                                       volunteer: current_api_user,
                                                       params: update_params
                                                     }).call
        render_data(data)
      end

      def refuse
        data = Api::V3::HelpRequestCases::Refuse.new({
                                                       help_request: @help_request,
                                                       volunteer: current_api_user,
                                                       params: update_params
                                                     }).call
        render_data(data)
      end

      protected

      def render_data(data)
        code = data[:errors] ? :not_acceptable : :ok
        render json: data, code: code
      end

      def fill_help_request
        @help_request = HelpRequest.find(params[:id])
      end

      def permitted_params
        params.permit(*Api::HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys)
      end

      def update_params
        params.permit(:comment, photos: [])
      end
    end
  end
end
