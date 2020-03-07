class ArticlePresenter
  def initialize(article)
    @article = article
  end

  attr_reader :article

  def call
    {
      name: article.name,
      text: article.content,
      type: article.kind
    }
  end
end