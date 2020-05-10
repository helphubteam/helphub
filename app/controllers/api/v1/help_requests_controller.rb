# frozen_string_literal: true

module Api
  module V1
    class HelpRequestsController < BaseController
      def index
        records = HelpRequestsSearcher.new(permitted_params).call
        response = records.map do |record|
          HelpRequestPresenter.new(record).call
        end
        render :json => response
      end

      private

      def permitted_params
        params.permit(:limit)
      end
    end
  end
end
