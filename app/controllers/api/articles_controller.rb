class Api::ArticlesController < ApplicationController
  def index
    articles =  ArticlesSearcher.new(params).call
    articles_data = present_articles(articles)
    render json: articles_data
  end

  private

  def present_articles(articles)
    articles.map do |article|
      ArticlePresenter.new(article).call
    end
  end
end
