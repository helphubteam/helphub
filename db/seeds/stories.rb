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
end
