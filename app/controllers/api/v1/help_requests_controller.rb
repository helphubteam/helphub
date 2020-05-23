# frozen_string_literal: true

module Api
  module V1
    class HelpRequestsController < Api::V1::BaseController
      before_action :fill_help_request, only: %i[assign submit refuse]

      def index
        records = Api::HelpRequestsSearcher.new(
          permitted_params, current_api_user
        ).call

        response = records.map do |record|
          Api::HelpRequestPresenter.new(record, current_api_user).call
        end
        render json: response
      end

      def assign
        data = HelpRequestCases::Assign.new({
                                              help_request: @help_request,
                                              volunteer: current_api_user
                                            }).call
        code = data[:errors] ? :not_acceptable : :ok
        render json: data, code: code
      end

      def submit
        data = HelpRequestCases::Submit.new({
                                              help_request: @help_request,
                                              volunteer: current_api_user
                                            }).call
        code = data[:errors] ? :not_acceptable : :ok
        render json: data, code: code
      end

      def refuse
        data = HelpRequestCases::Refuse.new({
                                              help_request: @help_request,
                                              volunteer: current_api_user
                                            }).call
        code = data[:errors] ? :not_acceptable : :ok
        render json: data, code: code
      end

      private

      def fill_help_request
        @help_request = HelpRequest.find(params[:id])
      end

      def permitted_params
        params.permit(*Api::HelpRequestsSearcher::DEFAULT_SEARCH_PARAMS.keys)
      end
    end
  end
end
