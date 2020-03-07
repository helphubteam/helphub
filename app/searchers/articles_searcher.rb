class ArticlesSearcher
  def initialize(params)
    @params = params
  end

  def call
    Article.limit(10)
  end
end