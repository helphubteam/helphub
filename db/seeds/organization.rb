unless Organization.any?
  Organization.create!(
      title: 'Новая организация',
      country: 'Беларусь',
      city: 'Минск',
      site: 'new_site.by'
  )
end
