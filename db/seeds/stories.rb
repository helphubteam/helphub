unless Story.any?
  story_names = [
    'Remote Development',
    'Make the World a Better Place',
    'Politics',
    'Coronavirus Update'
  ]

  Story.import(
    story_names.map do |name|
      { name: name }
    end
  )

  if Article.any?
    def pluck_articles
      count = rand(1..10)
      Article.order(Arel.sql('RANDOM()')).first(count)
    end

    Story.find_each do |story|
      story.articles = pluck_articles
    end
  end
end
