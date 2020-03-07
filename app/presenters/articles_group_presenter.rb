# frozen_string_literal: true

class ArticlesGroupPresenter < BasePresenter
  def call
    {
      field: target[:field],
      value: target[:value],
      articles: articles
    }
  end

  private

  def articles
    target[:articles].map do |article|
      ArticlePresenter.new(article).call
    end
  end
end
