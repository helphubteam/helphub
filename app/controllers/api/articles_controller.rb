# frozen_string_literal: true

class Api::ArticlesController < ApplicationController
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
    if search_params[:stories] && !search_params[:group]
      StoriesSearcher
    else
      ArticlesSearcher
    end
  end

  def build_presenter(search_params)
    if search_params[:group]
      ArticlesGroupPresenter
    elsif search_params[:stories]
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
