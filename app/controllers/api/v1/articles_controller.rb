# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseController
      def index
        search_params = permit_params(params)
        searcher = build_searcher(search_params)
        search_results = searcher.new(search_params).call
        presenter = build_presenter(search_params)
        response_data = present_list(search_results, presenter)
        render json: response_data
      end

      private

      def build_searcher(search_params)
        if search_params[:stories] == 'true' && search_params[:group].blank?
          StoriesSearcher
        else
          ArticlesSearcher
        end
      end

      def build_presenter(search_params)
        if search_params[:group].present?
          ArticlesGroupPresenter
        elsif search_params[:stories] == 'true'
          StoryPresenter
        else
          ArticlePresenter
        end
      end

      def present_list(list, presenter)
        list.map do |item|
          presenter.new(item).call
        end
      end

      def permit_params(params)
        keys = [:stories] +
               ArticlesSearcher::SEARCH_PARAMS +
               StoriesSearcher::SEARCH_PARAMS
        params.permit(*keys)
      end
    end
  end
end
