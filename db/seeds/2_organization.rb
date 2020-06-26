unless Organization.any?
  Organization.create!(
    title: 'Белая русь',
    country: 'Беларусь',
    city: 'Минск',
    site: 'new_site.by'
  )

  Organization.create!(
    title: 'Добрые люди',
    country: 'Россия',
    city: 'Москва',
    site: 'good.by'
  )
end
