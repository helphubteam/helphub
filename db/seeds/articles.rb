require 'csv'

unless Article.any?
  article_data = []
  CSV.foreach('./db/seeds/articles.csv', headers: true) do |row|
    article_data << {
      name: row['title'],
      content: row['text']
    }
  end
  Article.import(article_data)
end
