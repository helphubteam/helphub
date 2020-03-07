# frozen_string_literal: true

class StoryPresenter < BasePresenter
  def call
    super.merge({
                  name: target.name,
                  articles_count: target.articles.count,
                  articles: articles,
                  articles_types_count: articles_types_count,
                  last_article: last_article
                })
  end

  private

  def articles
    target.articles.map do |article|
      ArticlePresenter.new(article).call
    end
  end

  def last_article
    ArticlePresenter.new(target.articles.last).call
  end

  def articles_types_count
    target.articles.each_with_object({}) do |article, storage|
      storage[article.kind] ||= 0
      storage[article.kind] += 1
    end
  end
end
