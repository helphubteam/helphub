# frozen_string_literal: true

class ArticlePresenter < BasePresenter
  def call
    super.merge({
                  name: target.name,
                  text: target.content,
                  kind: target.kind
                })
  end
end
